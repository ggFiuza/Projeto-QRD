draw_clear(c_black);
draw_set_font(qrd_font(12));
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var _x = 112, _w = 800, _sep = 26;
var _y = 120;
for (var i = 0; i <= current; i++)
{
	var _full = lines[i].text;
	var _s = (i == current) ? string_copy(_full, 1, shown) : _full;
	draw_set_colour(lines[i].col);
	draw_set_alpha((i == current) ? 1 : 0.6);   //older paragraphs fade back a little
	//Blinking cursor after the last letter being typed
	if (i == current && (t div 20) mod 2 == 0) _s += "_";
	draw_text_ext(_x, _y, _s, _sep, _w);
	_y += string_height_ext(_full, _sep, _w) + 24;
}
draw_set_alpha(1);

//Prompt once the paragraph is complete
if (shown >= string_length(lines[current].text))
{
	draw_set_halign(fa_right);
	draw_set_colour(make_colour_rgb(120, 120, 120));
	draw_set_alpha(0.55 + 0.45 * sin(t / 15));
	draw_text(1024 - 48, 768 - 48, "ENTER");
	draw_set_alpha(1);
}

draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_colour(c_white);