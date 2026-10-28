//Automated playtest. Created by oMenu only when the QRD_AUTOTEST environment variable is set.
//Drives the game with simulated keys, prints "QRDTEST PASS/FAIL ..." lines to the debug output,
//saves screenshots (qrdtest_*.png in the game's save folder) and closes the game at the end.
exception_unhandled_handler(function(_e)
{
	var _f = file_text_open_append("qrdtest_log.txt");
	file_text_write_string(_f, "FAIL exception: " + string(_e.longMessage) + " | " + string(_e.stacktrace));
	file_text_writeln(_f);
	file_text_close(_f);
	game_end();
	return 0;
});

tt = 0;          //frames spent in the current task
task = 0;
pending_shot = "";
fails = 0;
mem = {};        //scratch values shared between frames of a task
floor_wall = noone;

log = function(_s)
{
	show_debug_message("QRDTEST " + _s);
	var _f = file_text_open_append("qrdtest_log.txt");
	file_text_write_string(_f, _s);
	file_text_writeln(_f);
	file_text_close(_f);
}
check = function(_name, _ok, _info)
{
	if (!_ok) fails++;
	log((_ok ? "PASS " : "FAIL ") + _name + "  " + string(_info));
}
//Luma's keys go through global.qrd_test_keys (read by oPlayer), other keys are simulated
global.qrd_test_keys = { left: false, right: false, up: false, down: false, jump: false, fire: false, jump_prev: false };
hold = function(_k, _down)
{
	var _t = global.qrd_test_keys;
	switch (_k)
	{
		case vk_left: _t.left = _down; break;
		case vk_right: _t.right = _down; break;
		case vk_up: case ord("W"): _t.up = _down; break;
		case vk_down: case ord("S"): _t.down = _down; break;
		case vk_space: _t.jump = _down; break;
		case ord("J"): _t.fire = _down; break;
		default: if (_down) keyboard_key_press(_k); else keyboard_key_release(_k);
	}
}
release_all = function()
{
	global.qrd_test_keys = { left: false, right: false, up: false, down: false, jump: false, fire: false, jump_prev: false };
	keyboard_key_release(vk_enter);
}
shoot_screen = function(_name) { pending_shot = _name; }
player_safe = function() { with (oPlayer) { invuln = 100005; hp = hp_max; } }
teleport = function(_x, _y)
{
	with (oPlayer) { x = _x; y = _y; vsp = 0; hsp = 0; run = 0; kb = 0; }
	with (oCamera) snap = true;
}
//Longest plain wall with clear space above it (for the movement measurements)
flat_floor = function()
{
	var _best = noone, _bw = 0;
	with (oWall)
	{
		if (object_index != oWall) continue;
		var _w = bbox_right - bbox_left;
		if (_w > _bw && _w >= 256 && collision_rectangle(bbox_left + 4, bbox_top - 140, bbox_right - 4, bbox_top - 1, oWall, false, true) == noone
			&& collision_rectangle(bbox_left + 4, bbox_top - 140, bbox_right - 4, bbox_top - 1, oPlat, false, true) == noone)
		{
			_best = id; _bw = _w;
		}
	}
	return _best;
}
standing = function() { return instance_exists(oPlayer) && oPlayer.is_grounded(); }
//oInfo deactivates every instance (this one too) while it is open, so the panel is probed,
//photographed and closed from time sources
panel_probe = function(_shot)
{
	global.qrdtest_panel = false;
	global.qrdtest_shot = _shot;
	call_later(30, time_source_units_frames, function() { global.qrdtest_panel = instance_exists(oInfo); });
	call_later(40, time_source_units_frames, function() { keyboard_key_press(vk_enter); });
	call_later(43, time_source_units_frames, function() { keyboard_key_release(vk_enter); });
}

//Each task is called once per frame with tt; it returns true when finished
tasks = [
	//1. Enter the tunnels
	function() {
		if (tt == 0) room_goto(rTuneis);
		if (tt == 50)
		{
			check("rTuneis loaded", room == rTuneis && instance_exists(oPlayer) && instance_exists(oCamera) && instance_exists(oTunBackground), room_get_name(room));
			check("start: Luma on the ground", standing(), "x=" + string(oPlayer.x) + " y=" + string(oPlayer.y));
			check("profile applied", oPlayer.phys.cam == "follow" && oPlayer.walksp == 4.5, "walksp=" + string(oPlayer.walksp));
			check("camera view 512x384", camera_get_view_width(view_camera[0]) == 512 && camera_get_view_height(view_camera[0]) == 384, "");
			shoot_screen("01_start");
		}
		return tt >= 52;
	},
	//2. Acceleration / top speed / braking on a long floor
	function() {
		if (tt == 0) { player_safe(); floor_wall = flat_floor(); check("flat floor found", floor_wall != noone, ""); if (floor_wall != noone) teleport(floor_wall.bbox_left + 40, floor_wall.bbox_top - 24); }
		if (tt == 30) { check("on flat floor", standing(), ""); mem.h = []; hold(vk_right, true); }
		if (tt > 30 && tt <= 60) array_push(mem.h, oPlayer.hsp);
		if (tt == 60) { hold(vk_right, false); mem.stop = 0; mem.keys = ""; }
		if (tt > 60 && tt <= 80) { if (oPlayer.hsp > 0) mem.stop++; if (tt < 64) mem.keys += string(keyboard_check(vk_right)) + "/" + string(oPlayer.hsp) + " "; }
		if (tt == 81)
		{
			//simulated keys reach oPlayer one frame later, so h[0] is still 0
			var _i0 = (mem.h[0] == 0) ? 1 : 0;
			check("accel: +1 per frame", abs(mem.h[_i0] - 1) < 0.01 && abs(mem.h[_i0 + 1] - 2) < 0.01 && abs(mem.h[_i0 + 2] - 3) < 0.01, string(mem.h[0]) + "," + string(mem.h[1]) + "," + string(mem.h[2]) + "," + string(mem.h[3]) + "," + string(mem.h[4]) + "," + string(mem.h[5]));
			check("top speed 4.5", abs(mem.h[20] - 4.5) < 0.01, mem.h[20]);
			check("braking ~9 frames", mem.stop >= 7 && mem.stop <= 11, string(mem.stop) + "  key/hsp after release: " + mem.keys);
		}
		return tt >= 82;
	},
	//3. Full jump, tapped jump, double jump
	function() {
		if (tt == 0) teleport(floor_wall.bbox_left + 120, floor_wall.bbox_top - 24);
		if (tt == 30) { mem.y0 = oPlayer.y; mem.top = oPlayer.y; hold(vk_space, true); }
		if (tt > 30 && tt < 90) mem.top = min(mem.top, oPlayer.y);
		if (tt == 70) hold(vk_space, false);
		if (tt == 95) { mem.full = mem.y0 - mem.top; check("full jump ~88px (2.75 tiles)", mem.full > 80 && mem.full < 96, mem.full); }
		if (tt == 100) { mem.top = oPlayer.y; hold(vk_space, true); }
		if (tt == 101) hold(vk_space, false);
		if (tt > 100 && tt < 150) mem.top = min(mem.top, oPlayer.y);
		if (tt == 150) { mem.tap = mem.y0 - mem.top; check("tapped jump is shorter", mem.tap > 4 && mem.tap < mem.full * 0.5, mem.tap); }
		if (tt == 160) { mem.top = oPlayer.y; hold(vk_space, true); }
		if (tt == 161) hold(vk_space, false);
		if (tt == 175) hold(vk_space, true);
		if (tt > 160 && tt < 240) mem.top = min(mem.top, oPlayer.y);
		if (tt == 240) { hold(vk_space, false); check("double jump goes higher", mem.y0 - mem.top > mem.full, mem.y0 - mem.top); }
		return tt >= 260;
	},
	//4. Shooting: rate, range (life), 4-way aim
	function() {
		if (tt == 0) { teleport(floor_wall.bbox_left + 60, floor_wall.bbox_top - 24); with (oPlayer) image_xscale = 1; mem.n = 0; mem.dirs = ""; }
		if (tt == 20) hold(ord("J"), true);
		if (tt >= 20 && tt < 52) with (oBullet) if (!variable_instance_exists(id, "counted")) { counted = true; other.mem.n++; other.mem.dirs += string(direction) + " "; }
		if (tt == 30) shoot_screen("02_shooting");
		if (tt == 52) { hold(ord("J"), false); check("fire rate: 4 shots in 32 frames", mem.n == 4, mem.n); check("shots go forward", string_pos("0 ", mem.dirs) == 1, mem.dirs); }
		if (tt == 80) check("shots expire (20 frames)", instance_number(oBullet) == 0, instance_number(oBullet));
		if (tt == 90) { hold(ord("W"), true); hold(ord("J"), true); }
		if (tt == 93) { var _up = false; with (oBullet) if (direction == 90) _up = true; check("aim up", _up, ""); hold(ord("J"), false); hold(ord("W"), false); }
		return tt >= 100;
	},
	//5. Hover: down + fire while falling
	function() {
		//Jump, then from the top of the jump hold down + fire: the fall stays at 2 px/frame
		if (tt == 0) { teleport(floor_wall.bbox_left + 200, floor_wall.bbox_top - 24); mem.vmax = 0; mem.air = 0; }
		if (tt == 20) hold(vk_space, true);
		if (tt == 40) { hold(vk_space, false); hold(ord("S"), true); hold(ord("J"), true); }
		if (tt > 45 && tt < 70 && !standing()) { mem.vmax = max(mem.vmax, oPlayer.vsp); mem.air++; }
		if (tt == 70) { check("hover caps fall speed at 2", mem.air > 10 && mem.vmax <= 2.01, "max vsp=" + string(mem.vmax) + " airborne frames=" + string(mem.air)); hold(ord("J"), false); hold(ord("S"), false); }
		//Same jump holding only down: falls faster than the normal cap of 8
		if (tt == 120) { hold(vk_space, true); mem.vmax = 0; }
		if (tt == 140) { hold(vk_space, false); hold(ord("S"), true); }
		if (tt > 140 && tt < 200 && !standing()) mem.vmax = max(mem.vmax, oPlayer.vsp);
		if (tt == 200) { hold(ord("S"), false); check("fast fall while holding down (>8)", mem.vmax > 8, mem.vmax); }
		return tt >= 220;
	},
	//6. Drop through a one-way platform
	function() {
		if (tt == 0)
		{
			mem.p = noone;
			with (oPlat) if (other.mem.p == noone && collision_rectangle(bbox_left, bbox_top - 80, bbox_right, bbox_top - 1, oWall, false, true) == noone
				&& collision_rectangle(bbox_left, bbox_bottom + 1, bbox_right, bbox_bottom + 90, oWall, false, true) == noone && bbox_right - bbox_left >= 64) other.mem.p = id;
			check("open platform found", mem.p != noone, "");
			if (mem.p != noone) teleport((mem.p.bbox_left + mem.p.bbox_right) / 2, mem.p.bbox_top - 40);
		}
		if (mem.p == noone) return true;
		if (tt == 40) check("lands on platform", standing() && oPlayer.bbox_bottom < mem.p.bbox_top + 2, oPlayer.bbox_bottom - mem.p.bbox_top);
		if (tt == 41) { hold(ord("S"), true); mem.dbg = ""; }
		if (tt == 44) hold(vk_space, true);
		if (tt == 46) hold(vk_space, false);
		if (tt >= 44 && tt <= 48) with (oPlayer) other.mem.dbg += "[" + string(key_jump) + string(key_down) + string(is_grounded()) + " y" + string(y) + "]";
		if (tt == 70) { hold(ord("S"), false); check("S + jump drops through", oPlayer.bbox_top > mem.p.bbox_bottom, string(oPlayer.y - mem.p.y) + " " + mem.dbg); }
		return tt >= 70;
	},
	//7. Ramps: walk up a chain of oSlopeR
	function() {
		if (tt == 0)
		{
			//Stand on the lowest ramp of the chain (rises to the right: surface y = bottom - (x - left))
			mem.s = instance_position(1536 + 4, 1760 + 30, oSlopeR);
			check("ramp found", mem.s != noone, "");
			if (mem.s != noone) teleport(mem.s.bbox_left + 8, mem.s.bbox_bottom - 50);
		}
		if (mem.s == noone) return true;
		if (tt == 30) { mem.x0 = oPlayer.x; mem.y0 = oPlayer.y; hold(vk_right, true); }
		if (tt == 45) shoot_screen("03_ramp");
		if (tt == 31) check("standing on the ramp", standing(), "y=" + string(oPlayer.y));
		if (tt == 90) { hold(vk_right, false); check("climbs the ramp", oPlayer.x > mem.x0 + 60 && oPlayer.y < mem.y0 - 40, "dx=" + string(oPlayer.x - mem.x0) + " dy=" + string(oPlayer.y - mem.y0)); }
		if (tt == 100) { mem.x1 = oPlayer.x; mem.y1 = oPlayer.y; mem.air = 0; hold(vk_left, true); }
		//Only measure while still above the bottom of the ramp chain (it ends at a drop)
		if (tt == 100) mem.trace = "";
		if (tt > 100 && tt < 122) mem.trace += "[" + string(oPlayer.x) + "," + string(oPlayer.y) + (standing() ? "g" : "A") + " v" + string(oPlayer.vsp) + "]";
		if (tt > 101 && oPlayer.x > mem.x0 + 8 && !standing()) mem.air++;
		if (tt > 101 && oPlayer.x <= mem.x0 + 8 && !variable_struct_exists(mem, "down")) { mem.down = true; hold(vk_left, false); check("walks back down, feet on the ramp", oPlayer.y > mem.y1 + 40 && mem.air < 3, "dx=" + string(oPlayer.x - mem.x1) + " dy=" + string(oPlayer.y - mem.y1) + " airborne=" + string(mem.air) + " " + mem.trace); }
		if (tt == 150) hold(vk_left, false);
		return tt >= 160;
	},
	//8. Saw damage, invulnerability and screen shake
	function() {
		if (tt == 0) { mem.saw = instance_find(oTunSawBig, 0); with (oPlayer) { invuln = 0; hp = hp_max; } mem.hp = oPlayer.hp; teleport(mem.saw.x + 32, mem.saw.y + 32); }
		if (tt == 3) check("saw hurts (-1 hp, 140f invuln, shake)", oPlayer.hp == mem.hp - 1 && oPlayer.invuln > 100 && oCamera.shake > 0, "hp=" + string(oPlayer.hp) + " inv=" + string(oPlayer.invuln) + " shake=" + string(oCamera.shake));
		if (tt == 20) check("no repeated hit while invulnerable", oPlayer.hp == mem.hp - 1, oPlayer.hp);
		return tt >= 25;
	},
	//9. Guard enemy chases when it sees Luma
	function() {
		if (tt == 0)
		{
			player_safe();
			mem.g = noone;
			with (oEnemyGuard) if (other.mem.g == noone && position_meeting(x + 120, bbox_bottom + 4, oWall) && collision_line(x, y, x + 120, y, oWall, false, true) == noone) other.mem.g = id;
			check("guard found", mem.g != noone, "");
			if (mem.g != noone) { mem.gx = mem.g.x; teleport(mem.g.x + 120, mem.g.y); }
		}
		if (mem.g == noone || !instance_exists(mem.g)) return true;
		if (tt == 60) check("guard walks toward Luma", mem.g.x > mem.gx + 8, "dx=" + string(mem.g.x - mem.gx));
		if (tt == 61) shoot_screen("04_guard");
		return tt >= 62;
	},
	//10. Breakable block
	function() {
		if (tt == 0) { mem.nb = instance_number(oTunBlock); var _b = instance_find(oTunBlock, 0); instance_create_layer(_b.x + 16, _b.y + 16, "Bullet", oBullet); }
		if (tt == 3) check("shot breaks a block", instance_number(oTunBlock) == mem.nb - 1, string(mem.nb) + " -> " + string(instance_number(oTunBlock)));
		return tt >= 4;
	},
	//11. Checkpoint, death and respawn
	function() {
		if (tt == 0) { mem.c = instance_find(oCheckpoint, 0); teleport(mem.c.x, mem.c.y - 24); }
		if (tt == 20) { check("checkpoint activates", global.checkpoint_room == rTuneis && mem.c.activated, ""); mem.cx = mem.c.x; mem.cy = mem.c.y; with (oPlayer) { invuln = 0; hp = 0; } }
		if (tt == 140) check("respawn at checkpoint after death", instance_exists(oPlayer) && abs(oPlayer.x - mem.cx) < 4 && abs(oPlayer.y - mem.cy) < 64 && !oPlayer.dead && oPlayer.hp == oPlayer.hp_max, "x=" + string(oPlayer.x) + " y=" + string(oPlayer.y));
		return tt >= 141;
	},
	//12. Screenshot tour (camera + parallax at several places)
	function() {
		if (tt == 0)
		{
			mem.pts = [];
			var _objs = [oCheckpoint, oEnemyGuard, oTunSawOrbit, oTunSawGen];   //not oExit: it would open the ending panel
			for (var i = 0; i < array_length(_objs); i++)
				with (_objs[i]) if (array_length(other.mem.pts) < 10) array_push(other.mem.pts, [x, y - 40]);
			mem.k = 0;
			check("tour points", array_length(mem.pts) > 3, array_length(mem.pts));
		}
		var _i = tt div 40;
		if (_i >= array_length(mem.pts)) return true;
		if (tt mod 40 == 0) { player_safe(); teleport(mem.pts[_i][0], mem.pts[_i][1]); with (oPlayer) { vsp = 0; } }
		if (tt mod 40 == 1 || tt mod 40 == 20) with (oPlayer) { y = other.mem.pts[_i][1]; vsp = 0; }
		if (tt mod 40 == 38) shoot_screen("05_tour_" + string(_i));
		return false;
	},
	//13. Info records: all five can be collected in the tunnels, each opens its panel
	function() {
		if (tt == 0)
		{
			mem.recs = [];
			with (oCollectible) array_push(other.mem.recs, [x, y, info]);
			check("five records in the tunnels", array_length(mem.recs) == 5, array_length(mem.recs));
			mem.n0 = qrd_collected_count();
		}
		var _i = tt div 60;
		if (_i >= array_length(mem.recs))
		{
			check("all records collected (HUD 5/5)", qrd_collected_count() == 5, qrd_collected_count());
			return true;
		}
		var _r = mem.recs[_i];
		if (tt mod 60 == 0) { player_safe(); teleport(_r[0], _r[1] - 8); panel_probe(_i == 0 ? "07_record_panel" : ""); }
		if (tt mod 60 == 50) check("record " + string(_r[2] + 1) + " collected with its panel", global.collected[_r[2]] && global.qrdtest_panel, "x=" + string(_r[0]) + " y=" + string(_r[1]));
		return false;
	},
	//14. Tunnel exit -> ending panel -> menu
	function() {
		if (tt == 0) { player_safe(); var _e = instance_find(oExit, 0); teleport(_e.x, _e.y - 30); panel_probe("06_ending"); }
		if (tt == 60) { check("exit opens the ending panel", global.qrdtest_panel, ""); check("ending returns to the menu", room == rMenu, room_get_name(room)); }
		return tt >= 81;
	},
	//End
	function() {
		release_all();
		log("DONE fails=" + string(fails));
		game_end();
		return true;
	}
];

log("start");
