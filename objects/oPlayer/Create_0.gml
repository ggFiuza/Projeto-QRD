//Art is drawn at half scale in Draw; the instance itself must stay at 1 (also keeps the 12x36 mask)
image_xscale = 1;
image_yscale = 1;
//Movement / combat settings for this room (see qrd_profile in scrQRD)
phys = qrd_profile(room);

hsp = 0;
vsp = 0;
grv = phys.grav;
walksp = phys.run_speed;
vsp_max = phys.fall_max;
run = 0;     //walking speed (hsp = run + knockback)
coyote = 0;

key_up = false;
key_down = false;
key_jump_held = false;
key_fire = false;

//Double jump
air_jumps_max = 1;
air_jumps = air_jumps_max;
was_grounded = false;

//Standing on a wall, or on a one-way platform (oPlat) that we are not inside of
is_grounded = function()
{
	return place_meeting(x, y + 1, oWall)
		|| (vsp >= 0 && !place_meeting(x, y, oPlat) && place_meeting(x, y + 1, oPlat));
}

//Jump / landing dust puffs at the feet
spawn_dust = function(_count, _spread)
{
	var _feet = bbox_bottom;
	repeat (_count)
	{
		with (instance_create_depth(x + random_range(-8, 8), _feet, depth + 1, oPuff))
		{
			hs = random_range(-_spread, _spread);
		}
	}
}

//Horizontal move one pixel at a time, stepping up ramps (oSlopeL/oSlopeR) and 1-2px ledges
//and following ramps down while walking on them (profile "slopes")
//Moves in whole pixels (sub-pixel remainder kept in xrem), like the reference, so the 1-2px ground checks stay exact
xrem = 0;
yrem = 0;
move_x_slopes = function(_dx)
{
	xrem += _dx;
	var _n = round(xrem);
	xrem -= _n;
	var _s = sign(_n);
	var _left = abs(_n);
	//Only stick to the ground going downhill if we start the move standing on it
	var _snap = (vsp >= 0 && place_meeting(x, y + 1, oWall));
	while (_left > 0)
	{
		var _step = _s;
		if (place_meeting(x + _step, y, oWall))
		{
			if (!place_meeting(x + _step, y - 1, oWall)) y -= 1;
			else if (!place_meeting(x + _step, y - 2, oWall)) y -= 2;
			else
			{
				hsp = 0;
				run = 0;
				kb = 0;
				xrem = 0;
				return;
			}
		}
		else if (_snap && !place_meeting(x + _step, y + 1, oWall))
		{
			//Follow the floor down: up to 6px per pixel walked, enough for the joint at the top
			//of a ramp (it used to detach there and fly down parallel to the ramp)
			for (var _k = 2; _k <= 7; _k++) if (place_meeting(x + _step, y + _k, oWall)) { y += _k - 1; break; }
		}
		x += _step;
		_left -= 1;
	}
}

controller = 0;

//Health / damage
hp_max = 3;
hp = hp_max;
invuln = 0;
kb = 0;
dead = false;
dead_timer = 0;

//Respawn at the last checkpoint touched in this room
if (!variable_global_exists("checkpoint_room")) global.checkpoint_room = -1;
if (global.checkpoint_room == room)
{
	x = global.checkpoint_x;
	y = global.checkpoint_y - 32;
}

if (phys.slopes)
{
	x = round(x);
	y = round(y);
}

//window_set_cursor (cr_none);
//cursor_sprite = spr_CustomCursor;
