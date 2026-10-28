//Door from the tunnel tileset (sTunDoor, origin bottom centre); the art starts 12px below the frame top
draw_sprite(sTunDoor, 0, x, y);
var _y1 = y - 52;
var _glow = 0.5 + 0.5 * sin(pulse / 12);

//Label and arrow above
draw_set_font(qrd_font(8));   //world text under the 2x tunnel camera, same as the hints
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
draw_set_colour(make_colour_rgb(80, 200, 255));
var _a = _y1 - 14 - 4 * _glow;
draw_triangle(x - 10, _a - 12, x + 10, _a - 12, x, _a, false);
draw_text(x, _a - 16, "SAÍDA");
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_colour(c_white);
