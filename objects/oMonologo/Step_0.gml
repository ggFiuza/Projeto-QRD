t++;

if (keyboard_check_pressed(vk_escape)) { room_goto(rChefe); exit; }

var _text = lines[current].text;
var _len = string_length(_text);
var _confirm = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space) || gamepad_button_check_pressed(0, gp_face1);

if (shown < _len)
{
	if (_confirm) shown = _len;
	else if (--wait <= 0)
	{
		shown++;
		//Typewriter rhythm: a beat after punctuation
		var _c = string_char_at(_text, shown);
		wait = (_c == "." || _c == ":") ? 14 : ((_c == ",") ? 7 : 2);
	}
}
else if (_confirm)
{
	if (current < array_length(lines) - 1) { current++; shown = 0; wait = 20; }
	else room_goto(rChefe);
}