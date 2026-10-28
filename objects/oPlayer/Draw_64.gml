//HUD: health and collected records
var _x = 24;
var _y = 20;

draw_set_font(qrd_font(16));
draw_set_halign(fa_left);
draw_set_valign(fa_top);

draw_set_colour(c_black);
draw_text(_x + 2, _y + 2, "VIDA");
draw_set_colour(c_white);
draw_text(_x, _y, "VIDA");

for (var i = 0; i < hp_max; i++)
{
	//Heart (16x16) at 2x; a lost one stays as a faded outline of itself
	draw_sprite_ext(sHeart, 0, _x + 96 + i * 34, _y - 7, 2, 2, 0, c_white, (i < hp) ? 1 : 0.3);
}

var _rec = "REGISTROS  " + string(qrd_collected_count()) + "/" + string(QRD_INFO_COUNT);
draw_set_colour(c_black);
draw_text(_x + 2, _y + 32, _rec);
draw_set_colour(make_colour_rgb(255, 220, 60));
draw_text(_x, _y + 30, _rec);

draw_set_font(-1);
draw_set_colour(c_white);
