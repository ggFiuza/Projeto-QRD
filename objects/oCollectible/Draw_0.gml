//Team's record sprite (scroll, article Figure 2) with a soft pulsing glow behind it
var _y = y + sin(degtorad(bob)) * 4;
var _glow = 0.18 + 0.08 * sin(degtorad(bob * 2));

draw_set_colour(make_colour_rgb(255, 220, 60));
draw_set_alpha(_glow);
draw_circle(x, _y, 20, false);
draw_set_alpha(1);
draw_set_colour(c_white);

draw_sprite(sRecord, 0, x, _y);
