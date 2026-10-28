//Tunnel parallax (same planes and rates as oTunBackground), scrolling with the run
var _py = -14;
draw_sprite_tiled_ext(sTunBk5, 0, -scroll * (1 - 1 / 1.3), _py, 2, 2, c_white, 1);
draw_sprite_tiled_ext(sTunBk4, 0, -scroll * (1 - 1 / 1.35), _py, 2, 2, c_white, 1);
draw_sprite_tiled_ext(sTunBk3, 0, -scroll * (1 - 1 / 1.4), _py, 2, 2, c_white, 1);
draw_sprite_tiled_ext(sTunBk2, 0, -scroll * (1 - 1 / 1.45), _py, 2, 2, c_white, 1);
draw_sprite_tiled_ext(sTunBk1, 0, -scroll * (1 - 1 / 1.5), _py, 2, 2, c_white, 1);

//Track: tunnel floor tiles (19 on top, 27, then 35) at 2x
var _ox = -(scroll mod 64);
for (var _x = _ox; _x < 1024; _x += 64)
{
	draw_sprite_part_ext(sTunTiles, 0, 96, 64, 32, 32, _x, ground_y, 2, 2, c_white, 1);
	draw_sprite_part_ext(sTunTiles, 0, 96, 96, 32, 32, _x, ground_y + 64, 2, 2, c_white, 1);
	draw_sprite_part_ext(sTunTiles, 0, 96, 128, 32, 32, _x, ground_y + 128, 2, 2, c_white, 1);
}

//Robots (tunnel art at 2x, facing left)
for (var i = 0; i < array_length(enemies); i++)
{
	var _e = enemies[i];
	if (_e.dead) draw_sprite_ext(sEnemyD, min(1, _e.t div 4), _e.x, ground_y - 14, -2, 2, 0, c_white, 1);
	else draw_sprite_ext(sEnemyR, (_e.t div 4) mod 4, _e.x, ground_y - 46, -2, 2, 0, c_white, 1);
}

//Luma, blinking after a hit
if (luma_hurt mod 8 < 5)
{
	var _air = (luma_y < ground_y - 45);
	var _spr = _air ? sPlayerA : sPlayerR;
	var _img = _air ? ((luma_vsp < 0) ? 0 : 1) : ((pulse div 4) mod 4);
	var _s = 2 * QRD_LUMA_SCALE;   //screen = world x2
	draw_sprite_ext(_spr, _img, luma_x, luma_y + 46 - 46 * _s, _s, _s, 0, c_white, 1);
	draw_sprite_ext(sGun, 0, luma_x, luma_y + 46 - 26 * _s, _s, _s, 0, c_white, 1);
}

for (var i = 0; i < array_length(shots); i++)
	draw_sprite_ext(sBullet, (shots[i].t < 4) ? 0 : 1, shots[i].x, shots[i].y, 1, 1, 0, c_white, 1);
for (var i = 0; i < array_length(effects); i++)
	draw_sprite_ext(sBulletHit, min(2, effects[i].t div 4), effects[i].x, effects[i].y, 1, 1, 0, c_white, 1);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Title shadow
draw_set_colour(c_black);
draw_set_font(qrd_font(40));
draw_text(516, 124, "QUANDO AS RAÍZES");
draw_set_font(qrd_font(48));
draw_text(516, 179, "DESPEDAÇAM");

// Title main fill
draw_set_font(qrd_font(40));
draw_set_colour(make_colour_rgb(230,210,160));
draw_text(512, 120, "QUANDO AS RAÍZES");
draw_set_font(qrd_font(48));
draw_set_colour(make_colour_rgb(235,110,60));
draw_text(512, 175, "DESPEDAÇAM");

// Pulsing prompt
var _a = 0.55 + 0.45 * sin(pulse / 20);
draw_set_alpha(_a);
draw_set_font(qrd_font(18));
draw_set_colour(c_black);
draw_text(514, 282, "PRESSIONE ENTER PARA COMEÇAR");
draw_set_colour(c_white);
draw_text(512, 280, "PRESSIONE ENTER PARA COMEÇAR");
draw_set_alpha(1);

draw_set_font(qrd_font(12));
draw_set_colour(c_black);
draw_text(514, 330, "ESPAÇO: pular   Z: atirar   ESC: sair");
draw_set_colour(make_colour_rgb(235, 225, 190));
draw_text(512, 328, "ESPAÇO: pular   Z: atirar   ESC: sair");

draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_colour(c_white);