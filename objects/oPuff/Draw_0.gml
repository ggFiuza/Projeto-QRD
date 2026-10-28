var _t = life / max_life;
draw_set_alpha(_t * 0.75);
draw_set_colour(make_colour_rgb(235, 235, 225));
draw_circle(round(x), round(y), round(radius * (1.7 - _t * 0.7)), false);
draw_set_alpha(1);
draw_set_colour(c_white);
