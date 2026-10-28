//First step: freeze the last frame as a backdrop, then pause everything else
if (t == 0)
{
	snap = sprite_create_from_surface(application_surface, 0, 0, surface_get_width(application_surface), surface_get_height(application_surface), false, false, 0, 0);
	instance_deactivate_all(true);
}
t++;
pulse++;

//Short delay so the key that triggered the panel does not close it
var _confirm = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space) || keyboard_check_pressed(ord("E")) || gamepad_button_check_pressed(0, gp_face1);
if (t > 20 && _confirm)
{
	instance_activate_all();
	if (sprite_exists(snap)) sprite_delete(snap);
	if (goto_menu) room_goto(rMenu);
	else if (goto_room != -1) room_goto(goto_room);
	instance_destroy();
}
