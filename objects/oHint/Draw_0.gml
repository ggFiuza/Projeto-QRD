if (text == "") exit;

draw_set_font(qrd_font(size));
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);

var _pad = size / 16;   //box padding scales with the font (20 x 10 at the default size)
var _sep = size * 1.75;   //Press Start 2P has no line gap of its own
var _w = string_width_ext(text, _sep, -1) + 20 * _pad;
var _h = string_height_ext(text, _sep, -1) + 10 * _pad;

draw_set_alpha(0.6);
draw_set_colour(c_black);
draw_roundrect(x - _w / 2, y - _h, x + _w / 2, y, false);
draw_set_alpha(1);
draw_set_colour(make_colour_rgb(235, 225, 190));
draw_text_ext(x, y - 5 * _pad, text, _sep, -1);

draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_colour(c_white);
