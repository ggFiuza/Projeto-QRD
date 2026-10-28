var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

//Frozen game frame, dimmed
if (sprite_exists(snap)) draw_sprite_stretched(snap, 0, 0, 0, _gw, _gh);
draw_set_alpha(0.6);
draw_set_colour(c_black);
draw_rectangle(0, 0, _gw, _gh, false);
draw_set_alpha(1);

//Panel: parchment (sPaper, 3x3 pieces of 32px) drawn at 2x, so its size snaps to 64px pieces.
//Fonts on the Press Start 2P grid: 18pt = 24px, 12pt = 16px.
var _piece = 64;
var _pad = 48;   //text inset from the paper edge
var _w = min(896, floor((_gw - 64) / _piece) * _piece);
var _tw = _w - 2 * _pad;
draw_set_font(qrd_font(12));
var _body_h = string_height_ext(text, 24, _tw);
//title (24) + gap, body, gap + footer line (16), margins
var _h = clamp(ceil((_body_h + 168) / _piece) * _piece, 4 * _piece, floor((_gh - 32) / _piece) * _piece);
var _x1 = (_gw - _w) div 2;
var _y1 = (_gh - _h) div 2;

var _nx = _w div _piece, _ny = _h div _piece;
for (var _i = 0; _i < _nx; _i++)
{
	var _sx = (_i == 0) ? 0 : ((_i == _nx - 1) ? 64 : 32);
	for (var _j = 0; _j < _ny; _j++)
	{
		var _sy = (_j == 0) ? 0 : ((_j == _ny - 1) ? 64 : 32);
		draw_sprite_part_ext(sPaper, 0, _sx, _sy, 32, 32, _x1 + _i * _piece, _y1 + _j * _piece, 2, 2, c_white, 1);
	}
}

var _ink = make_colour_rgb(50, 34, 22);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(qrd_font(18));
draw_set_colour(make_colour_rgb(110, 46, 20));
draw_text(_x1 + _pad, _y1 + _pad - 8, title);

draw_set_font(qrd_font(12));
draw_set_colour(_ink);
draw_text_ext(_x1 + _pad, _y1 + _pad + 40, text, 24, _tw);

//Footer and prompt share the bottom line (left / right); at 16px per letter both fit in _tw
var _fy = _y1 + _h - _pad - 16;
if (footer != "")
{
	draw_set_colour(make_colour_rgb(40, 90, 40));
	draw_text(_x1 + _pad, _fy, footer);
}

//Prompt
if (t > 20)
{
	draw_set_halign(fa_right);
	draw_set_alpha(0.55 + 0.45 * sin(pulse / 15));
	draw_set_colour(_ink);
	draw_text(_x1 + _w - _pad, _fy, "ENTER para continuar");
	draw_set_alpha(1);
}

draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_colour(c_white);
