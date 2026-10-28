vsp = min(vsp + grv, 10);

var _grounded = place_meeting(x,y+1,oWall)
	|| (vsp >= 0 && !place_meeting(x,y,oPlat) && place_meeting(x,y+1,oPlat));

if (behavior == "guard")
{
	//Holds its post; while it can see Luma it walks toward her, but never off a ledge.
	//When it loses sight it stops and looks both ways before going back to its post.
	think--;
	if (think <= 0)
	{
		think = 5;
		var _sees = instance_exists(oPlayer) && !oPlayer.dead
			&& point_distance(x, y, oPlayer.x, oPlayer.y) < 480
			&& collision_line(x, y, oPlayer.x, oPlayer.y - 16, oWall, false, true) == noone;
		var _want = 0;
		if (_sees)
		{
			alert = true;
			rest = 0;
			var _d = sign(oPlayer.x - x);
			var _ahead = x + _d * 40;
			if (abs(oPlayer.x - x) > 16 && (position_meeting(_ahead, bbox_bottom + 4, oWall) || position_meeting(_ahead, bbox_bottom + 4, oPlat))) _want = _d;
		}
		else
		{
			if (alert) { alert = false; rest = 100; }
			if (rest > 0)
			{
				rest -= 5;
				if (rest == 50 || rest == 25) image_xscale = -image_xscale;
			}
			else if (abs(x - xstart) > 16) _want = sign(xstart - x);
		}
		hsp = qrd_approach(hsp, _want * 2, 1);
	}
}
else if (_grounded)
{
	//Turn around at ledges instead of walking off
	var _front = (hsp > 0) ? bbox_right + hsp : bbox_left + hsp;
	if (!position_meeting(_front, bbox_bottom + 2, oWall) && !position_meeting(_front, bbox_bottom + 2, oPlat)) hsp = -hsp;
}

//Horizontal Collision
if (place_meeting(x+hsp,y,oWall)) {
	while (!place_meeting(x+sign(hsp),y,oWall)) {
		x = x + sign(hsp);
	}
	hsp = (behavior == "walker") ? -hsp : 0;
}

x = x + hsp;

//One-way platforms: land only when falling from above
if (vsp >= 0 && !place_meeting(x,y,oPlat) && place_meeting(x,y+vsp+1,oPlat)) {
	while (!place_meeting(x,y+1,oPlat)) y = y + 1;
	vsp = 0;
}

//Vertical Collision
if (place_meeting(x,y+vsp,oWall)) {
	while (!place_meeting(x,y+sign(vsp),oWall)) {
		y = y + sign(vsp);
	}
	vsp = 0;
}

y = y + vsp;

//Animation

_grounded = place_meeting(x,y+1,oWall)
	|| (vsp >= 0 && !place_meeting(x,y,oPlat) && place_meeting(x,y+1,oPlat));
if (!_grounded) {
	sprite_index = sEnemyA;
	image_speed = 0;
	if (sign(vsp) > 0) image_index = 1; else image_index = 0 
}

else {
	image_speed = 0.4;
	if(sign(hsp) == 0) sprite_index = sEnemy; else sprite_index = sEnemyR;
}

if (hsp != 0) image_xscale = sign(hsp)