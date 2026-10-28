// QRD level data and run state.
// Top-level script code runs once at game start, before the first room.
// Texts are a first draft for the team to review against the article.

#macro QRD_INFO_COUNT 5

//Drawing scale of Luma's BIG art (0.5 = one art pixel per screen pixel with the 2x camera).
//Only the drawing grows: collision stays on sPlayerMask. Her feet are 46 art px below the origin
//and the scepter hand 26 art px above the feet, so both are placed from the feet.
#macro QRD_LUMA_SCALE 0.75

global.info = [
	{
    title: "Registro Perdido - Extinção",
    text: "Cerca de 1 milhão de espécies estão ameaçadas de extinção, principalmente devido à destruição de habitats, à exploração excessiva da natureza e às mudanças climáticas."
},
{
    title: "Registro Perdido - Água",
    text: "Cerca de 2,2 bilhões de pessoas não tinham acesso à água potável gerenciada com segurança em 2022, enquanto a poluição e o uso excessivo ameaçam os recursos hídricos."
},
{
    title: "Registro Perdido - Clima",
    text: "Em 2024, a temperatura média global atingiu cerca de 1,55 °C acima dos níveis pré-industriais, intensificando os riscos de eventos climáticos extremos."
},
{
    title: "Registro Perdido - Inteligência",
    text: "Os centros de dados consumiram cerca de 415 TWh de eletricidade em 2024. Até 2030, esse consumo pode mais que dobrar, impulsionado pela expansão da inteligência artificial."
},
{
    title: "Registro Perdido - Desmatamento",
    text: "Entre 1990 e 2020, o mundo perdeu aproximadamente 420 milhões de hectares de florestas devido ao desmatamento, destruindo habitats e agravando as mudanças climáticas."
}
];

//Shown at the exit of the tunnels: closes the demo with the hook to the antagonist.
//Draft text for the team to review.
global.ending = {
	title: "Fim da fase.",
	text: "Luma atravessa os túneis e chega à porta da antiga central de dados. Do outro lado, luzes azuis ainda piscam no ritmo das máquinas.\n\nUma voz ecoa pelos alto-falantes:\n\"Você chegou longe, Luma. Mas as raízes que você procura já são minhas.\"\n\n- Mariana\n\nContinua..."
};

//Shown when Ray Cat is defeated in rChefe. Draft text for the team to review.
global.boss_victory = {
	title: "Vitória!",
	text: "O guardião da central de dados se desfaz em faíscas e fumaça. As luzes azuis se apagam, uma a uma.\n\nLuma respira fundo: as raízes ainda podem ser salvas."
};

global.collected = array_create(QRD_INFO_COUNT, false);
global.checkpoint_room = -1;
global.checkpoint_x = 0;
global.checkpoint_y = 0;

/// Number of info records collected in this run
function qrd_collected_count()
{
	var _n = 0;
	for (var i = 0; i < QRD_INFO_COUNT; i++) if (global.collected[i]) _n++;
	return _n;
}

/// Start a fresh run (called by the menu)
function qrd_reset_run()
{
	global.collected = array_create(QRD_INFO_COUNT, false);
	global.checkpoint_room = -1;
	global.checkpoint_x = 0;
	global.checkpoint_y = 0;
}

/// UI font with Portuguese accents (the built-in font has none). Press Start 2P, SIL OFL 1.1,
/// shipped as an included file with its licence. Created on first use and cached per size.
/// Pixel font on an 8px grid: use sizes that are multiples of 8 so it stays sharp.
function qrd_font(_size)
{
	if (!variable_global_exists("fonts")) global.fonts = {};
	var _key = string(_size);
	if (!variable_struct_exists(global.fonts, _key) || !font_exists(global.fonts[$ _key]))
	{
		font_add_enable_aa(false);
		global.fonts[$ _key] = font_add("fonts/PressStart2P-Regular.ttf", _size, false, false, 32, 255);
	}
	return global.fonts[$ _key];
}

/// Open the info panel; pass goto_menu = true to return to the menu when it closes,
/// or a room in goto_room to go there instead
function qrd_show_info(_title, _text, _footer, _goto_menu, _goto_room = -1)
{
	with (instance_create_depth(0, 0, -10000, oInfo))
	{
		title = _title;
		text = _text;
		footer = _footer;
		goto_menu = _goto_menu;
		goto_room = _goto_room;
	}
}

/// Move a value toward a target by at most _step
function qrd_approach(_value, _target, _step)
{
	return (_value < _target) ? min(_value + _step, _target) : max(_value - _step, _target);
}

/// Movement, combat and camera settings for a room.
/// The defaults are the original QRD feel; rTuneis uses the reference platformer's values
/// (measured in its 16px level at 60 fps) doubled for this project's 32px grid.
function qrd_profile(_room)
{
	var _p = {
		run_speed: 4,        //max horizontal speed
		run_accel: 0,        //0 = instant start/stop
		run_fric: 0,
		grav: 0.3,
		fall_max: 10,
		fast_fall: 0,        //extra fall speed while holding down
		jump: 7,
		air_jump: 6.5,
		jump_cut: 1,         //upward speed is divided by this every frame the jump key is not held
		coyote: 0,           //frames after leaving a ledge in which a jump still counts as grounded
		drop_through: false, //down + jump falls through oPlat
		slopes: false,       //walk up/down ramps (oSlopeL / oSlopeR) and 1-2px steps
		invuln: 60,
		hurt_shake: 0,
		aim: "mouse",        //"mouse", or "keys": facing / up / down like the reference
		fire_delay: 5,
		bullet_speed: 25,
		bullet_life: -1,     //frames, -1 = until it hits something
		hover: false,        //hold down + fire while falling to slow the fall
		cam: "qrd"
	};
	if (_room == rTuneis || _room == rChefe)
	{
		_p.run_speed = 4.5;  _p.run_accel = 1;    _p.run_fric = 0.5;
		_p.grav = 0.5;       _p.fall_max = 8;     _p.fast_fall = 6;
		_p.jump = 9.4;       _p.air_jump = 9.4;   _p.jump_cut = 1.2;   _p.coyote = 10;
		_p.drop_through = true;
		_p.slopes = true;
		_p.invuln = 140;     _p.hurt_shake = 36;
		_p.aim = "keys";     _p.fire_delay = 8;   _p.bullet_speed = 10; _p.bullet_life = 20;
		_p.hover = true;
		_p.cam = "follow";
	}
	return _p;
}

/// Damage Luma by one point unless she is invulnerable or dead.
/// _src_x: x of whatever hit her (knockback pushes away from it)
function qrd_hurt_player(_src_x, _kb, _vsp)
{
	with (oPlayer)
	{
		if (!dead && invuln <= 0)
		{
			hp--;
			invuln = phys.invuln;
			var _dir = sign(x - _src_x);
			if (_dir == 0) _dir = -image_xscale;
			kb = _dir * _kb;
			vsp = _vsp;
			if (phys.hurt_shake > 0) with (oCamera) shake = other.phys.hurt_shake;
		}
	}
}

/// Draws Mariana (the boss) in place of Ray Cat. Her art (sMariana) has one frame, so the cat's
/// animation, which the boss objects still play invisibly for their timing, becomes motion on it.
/// Her eyes glow red (sMarianaGlow, additive). _white = hit flash.
function qrd_draw_mariana(_spr, _img, _x, _y, _xs, _alpha, _white)
{
	var _n = max(1, sprite_get_number(_spr));
	var _p = (_img mod _n) / _n;   //0..1 through the cat animation
	var _dx = 0, _dy = 0, _ang = 0, _sx = 1, _sy = 1;
	var _glow = 0.75 + 0.25 * sin(current_time / 150);
	switch (_spr)
	{
		case sChefeCat:       _dy = sin(_p * 2 * pi) * 2; _ang = sin(_p * 4 * pi) * 2; break;                          //floating
		case sChefeCatLick:   _ang = sin(_p * 2 * pi) * 5; break;                                                     //waiting on the rail
		case sChefeCatScream: _dx = (floor(_img) mod 2 == 0) ? -2 : 2; _sx = 1.06; _sy = 1.06; _glow = 1.5; break;    //scream: shakes
		case sChefeCatEmerge: _sx = 0.96; _sy = 1.05; _glow = 1.2; break;                                             //rising
		case sChefeCatPop:    _sx = 1 + 0.15 * (1 - _p); _sy = _sx; _glow = 1.6; break;                               //pops into the fight
		case sChefeCatAttack: _ang = -8 * sign(_xs) * sin(_p * pi); _sx = 1 + 0.08 * sin(_p * pi); _sy = _sx; _glow = 1.4; break;
		case sChefeCatSad:    _ang = 10 * min(1, _p * 3); _dy = 4 * min(1, _p * 3); _glow = 0.35; break;               //hurt, droops
		case sChefeCatDeath:  _ang = sin(current_time / 40) * 6; _glow = 0.3; break;
	}
	var _bx = _x + _dx, _by = _y + _dy;
	draw_sprite_ext(sMariana, 0, _bx, _by, _xs * _sx, _sy, _ang, c_white, _alpha);
	if (_white)
	{
		shader_set(shWhite);
		draw_sprite_ext(sMariana, 0, _bx, _by, _xs * _sx, _sy, _ang, c_white, 1);
		shader_reset();
	}
	//Eyes at art (33,25) and (46,25), origin (40,46): offsets (-7,-21) and (6,-21), turned with her
	gpu_set_blendmode(bm_add);
	var _ex = [-7, 6];
	for (var i = 0; i < 2; i++)
	{
		var _ox = _ex[i] * _xs * _sx, _oy = -21 * _sy;
		var _rx = _ox * dcos(_ang) + _oy * dsin(_ang);
		var _ry = -_ox * dsin(_ang) + _oy * dcos(_ang);
		var _gs = 1 + max(0, _glow - 1);
		draw_sprite_ext(sMarianaGlow, 0, _bx + _rx, _by + _ry, _gs, _gs, 0, make_colour_rgb(255, 40, 30), min(1, _glow) * _alpha);
	}
	gpu_set_blendmode(bm_normal);
}
