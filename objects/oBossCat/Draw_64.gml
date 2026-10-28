//Boss name and health bar at the bottom of the screen (reference layout, sprite drawn at 2x on the GUI)
if (dead) exit;
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _bw = sprite_get_width(sChefeHealth);      //384 (192 reference px)
var _bh = sprite_get_height(sChefeHealth);
var _bx = (_gw - _bw * 2) / 2;
var _by = _gh - 64;

draw_set_font(qrd_font(16));
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
draw_set_colour(c_black);
draw_text(_gw / 2 + 2, _by - 6, boss_name);
draw_set_colour(c_white);
draw_text(_gw / 2, _by - 8, boss_name);

draw_sprite_ext(sChefeHealth, 0, _bx, _by, 2, 2, 0, c_white, 1);
draw_sprite_part_ext(sChefeHealth, 2, 0, 0, floor(_bw * clamp(hp_smooth / hp_max, 0, 1)), _bh, _bx, _by, 2, 2, c_white, 1);
draw_sprite_part_ext(sChefeHealth, 1, 0, 0, ceil(_bw * clamp(hp / hp_max, 0, 1)), _bh, _bx, _by, 2, 2, c_white, 1);

draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_colour(c_white);
