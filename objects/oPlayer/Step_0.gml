//Esc: back to the menu
if (keyboard_check_pressed(vk_escape)) { room_goto(rMenu); exit; }

//Dead: wait, then restart the room (respawns at the last checkpoint)
if (dead)
{
	dead_timer--;
	if (dead_timer <= 0) room_restart();
	exit;
}

//Get Player Input
key_left = keyboard_check(vk_left) || keyboard_check(ord("A"));
key_right = keyboard_check(vk_right) || keyboard_check(ord("D"));
key_up = keyboard_check(vk_up) || keyboard_check(ord("W"));
key_down = keyboard_check(vk_down) || keyboard_check(ord("S"));
if (phys.aim == "keys")
{
	//Up/W aim and look up in this mode, so jump is on Space / X / K
	key_jump = keyboard_check_pressed(vk_space) || keyboard_check_pressed(ord("X")) || keyboard_check_pressed(ord("K"));
	key_jump_held = keyboard_check(vk_space) || keyboard_check(ord("X")) || keyboard_check(ord("K"));
}
else
{
	key_jump = keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
	key_jump_held = keyboard_check(vk_space) || keyboard_check(vk_up) || keyboard_check(ord("W"));
}
key_fire = mouse_check_button(mb_left) || keyboard_check(ord("J")) || keyboard_check(ord("Z"))
	|| gamepad_button_check(0, gp_shoulderrb) || gamepad_button_check(0, gp_face3);

if (key_left) || (key_right) || (key_jump)
{
	controller = 0;
}

if (abs(gamepad_axis_value(0,gp_axislh)) > 0.2)
{
	key_left = abs(min(gamepad_axis_value(0,gp_axislh),0));
	key_right = max(gamepad_axis_value(0,gp_axislh),0);
	controller = 1;
}
if (gamepad_axis_value(0, gp_axislv) < -0.5) key_up = true;
if (gamepad_axis_value(0, gp_axislv) > 0.5) key_down = true;

if  (gamepad_button_check_pressed(0,gp_face1))
{
	key_jump = 1;
	controller = 1;
}
if (gamepad_button_check(0, gp_face1)) key_jump_held = true;

//Automated playtest (oQrdTest) drives the keys here, so it works even without window focus
if (variable_global_exists("qrd_test_keys") && is_struct(global.qrd_test_keys))
{
	var _k = global.qrd_test_keys;
	key_left = _k.left;
	key_right = _k.right;
	key_up = _k.up;
	key_down = _k.down;
	key_jump = _k.jump && !_k.jump_prev;
	key_jump_held = _k.jump;
	key_fire = _k.fire;
	_k.jump_prev = _k.jump;
}

//Calculate Moviment
var move = key_right - key_left;

if (phys.run_accel <= 0)
{
	run = move * walksp;
}
else
{
	//Accelerate toward the target speed; turning around brakes first
	if (move != 0)
	{
		if (sign(run) == -sign(move)) run = qrd_approach(run, 0, phys.run_fric);
		run = qrd_approach(run, move * walksp, phys.run_accel);
	}
	else run = qrd_approach(run, 0, phys.run_fric);
}
hsp = run + kb;
kb = kb * 0.8;
if (abs(kb) < 0.5) kb = 0;

//Gravity (holding down falls faster when the profile allows it)
vsp = qrd_approach(vsp, vsp_max + (key_down ? phys.fast_fall : 0), grv);

var _grounded = is_grounded();
if (_grounded)
{
	air_jumps = air_jumps_max;
	coyote = phys.coyote;
}
else if (coyote > 0) coyote--;

if (key_jump)
{
	if (phys.drop_through && key_down && _grounded && !place_meeting(x, y + 1, oWall) && place_meeting(x, y + 1, oPlat))
	{
		//Drop through the one-way platform
		y += 1;
		spawn_dust(3, 1);
	}
	else if (_grounded || coyote > 0)
	{
		vsp = -phys.jump;
		coyote = 0;
		spawn_dust(4, 1.2);
	}
	else if (air_jumps > 0)
	{
		air_jumps--;
		vsp = -phys.air_jump;
		spawn_dust(6, 2);
	}
}

//Variable jump height: releasing the jump key cuts the rise short
if (phys.jump_cut > 1 && vsp < 0 && !key_jump_held && !(key_fire && key_down)) vsp /= phys.jump_cut;

//Hover: firing downward while falling slows the fall
if (phys.hover && key_down && key_fire && vsp > 2) vsp = 2;

//Horizontal Collision
if (phys.slopes)
{
	move_x_slopes(hsp);
}
else
{
	if (place_meeting(x+hsp,y,oWall)) {
		while (!place_meeting(x+sign(hsp),y,oWall)) {
			x = x + sign(hsp);
		}
		hsp = 0;
		run = 0;
		kb = 0;
	}

	x = x + hsp;
}

//One-way platforms: only land on them when falling from above
if (vsp >= 0 && !place_meeting(x,y,oPlat) && place_meeting(x,y+vsp+1,oPlat)) {
	while (!place_meeting(x,y+1,oPlat)) y = y + 1;
	vsp = 0;
}

//Vertical Collision
var _vsp_before = vsp;
if (place_meeting(x,y+vsp,oWall)) {
	while (!place_meeting(x,y+sign(vsp),oWall)) {
		y = y + sign(vsp);
	}
	vsp = 0;
}

if (phys.slopes)
{
	//Whole pixels only (see move_x_slopes)
	yrem += vsp;
	var _dy = round(yrem);
	yrem -= _dy;
	if (vsp == 0) yrem = 0;
	y += _dy;
}
else y = y + vsp;

//Landing dust
var _on_ground = is_grounded();
if (_on_ground && !was_grounded && _vsp_before > 3) spawn_dust(5, 1.5);
was_grounded = _on_ground;

//Contact damage from enemies
if (invuln > 0)
{
	invuln--;
}
else
{
	var _enemy = instance_place(x,y,oEnemy);
	if (_enemy != noone) qrd_hurt_player(_enemy.x, 6, -4);
}

//Fell out of the room
if (y > room_height + 64) hp = 0;

//Death
if (hp <= 0)
{
	dead = true;
	dead_timer = 90;
	visible = false;
	with (instance_create_layer(x,y,layer,oDead))
	{
		sprite_index = sPlayerA;
		image_xscale = other.image_xscale * QRD_LUMA_SCALE;
		image_yscale = QRD_LUMA_SCALE;
		hsp = -other.image_xscale * 2;
		vsp = -4;
	}
	exit;
}

//Animation

if (!is_grounded()) {
	sprite_index = sPlayerA;
	image_speed = 0;
	if (sign(vsp) > 0) image_index = 1; else image_index = 0;
}

else {
	image_speed = 1;
	if(sign(hsp) == 0) sprite_index = sPlayer; else sprite_index = sPlayerR;
}

if (move != 0) image_xscale = sign(move);

//Blink while invulnerable
image_alpha = (invuln > 0 && (invuln div 4) mod 2 == 0) ? 0.35 : 1;
