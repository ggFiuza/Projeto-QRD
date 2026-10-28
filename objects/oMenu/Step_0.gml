pulse += 1;

if (keyboard_check_pressed(vk_enter) || gamepad_button_check_pressed(0, gp_start)) {
	room_goto(rTuneis);
	exit;
}

//F3: straight to the boss fight (rChefe)
if (keyboard_check_pressed(vk_f3)) { room_goto(rChefe); exit; }

//Esc: quit the game
if (keyboard_check_pressed(vk_escape)) game_end();

scroll += run_speed;
var _ground = ground_y - 45;

//Input: jump (with double jump) and the scepter shot, like in the level
var _jump = keyboard_check_pressed(vk_space) || keyboard_check_pressed(ord("W")) || keyboard_check_pressed(vk_up)
	|| keyboard_check_pressed(ord("K")) || keyboard_check_pressed(ord("X")) || gamepad_button_check_pressed(0, gp_face1);
var _fire = keyboard_check(ord("Z")) || keyboard_check(ord("J")) || mouse_check_button(mb_left) || gamepad_button_check(0, gp_face3);
if (_jump || _fire) idle = 0; else idle++;

//Demo: jump when a robot gets close
if (idle > idle_demo && luma_y >= _ground)
{
	for (var i = 0; i < array_length(enemies); i++)
	{
		var _dx = enemies[i].x - luma_x;
		if (!enemies[i].dead && _dx > 70 && _dx < 150) { _jump = true; break; }
	}
}

if (_jump && luma_jumps < 2)
{
	luma_vsp = (luma_jumps == 0) ? -17 : -14;
	luma_jumps++;
}
luma_vsp += 1;
luma_y += luma_vsp;
if (luma_y >= _ground) { luma_y = _ground; luma_vsp = 0; luma_jumps = 0; }
luma_hurt = max(0, luma_hurt - 1);

fire_delay--;
if (_fire && fire_delay < 0)
{
	fire_delay = 8;
	array_push(shots, { x: luma_x + 34, y: luma_y + 46 - 52 * QRD_LUMA_SCALE, t: 0 });
}

//Robots: run left toward Luma, a bit faster than the track
spawn_t--;
if (spawn_t <= 0)
{
	spawn_t = irandom_range(70, 160);
	array_push(enemies, { x: 1024 + 60, dead: false, t: 0 });
}
for (var i = array_length(enemies) - 1; i >= 0; i--)
{
	var _e = enemies[i];
	_e.t++;
	_e.x -= _e.dead ? run_speed : run_speed + 2;
	if (!_e.dead && luma_hurt == 0 && abs(_e.x - luma_x) < 40 && luma_y > _ground - 60) luma_hurt = 60;
	if (_e.x < -80 || (_e.dead && _e.t > 30)) array_delete(enemies, i, 1);
}

//Shots
for (var i = array_length(shots) - 1; i >= 0; i--)
{
	var _s = shots[i];
	_s.t++;
	_s.x += 16;
	var _hit = false;
	for (var k = 0; k < array_length(enemies); k++)
	{
		var _e = enemies[k];
		if (!_e.dead && abs(_s.x - _e.x) < 34 && abs(_s.y - (ground_y - 40)) < 46)
		{
			_e.dead = true;
			_e.t = 0;
			_hit = true;
			break;
		}
	}
	if (_hit) array_push(effects, { x: _s.x, y: _s.y, t: 0 });
	if (_hit || _s.t > 40) array_delete(shots, i, 1);
}

//Impacts: 3 frames at 15 fps, carried along with the track
for (var i = array_length(effects) - 1; i >= 0; i--)
{
	var _f = effects[i];
	_f.t++;
	_f.x -= run_speed;
	if (_f.t >= 12) array_delete(effects, i, 1);
}