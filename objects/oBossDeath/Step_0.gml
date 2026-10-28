timer--;
if (timer <= 0) falling = true;

if (falling)
{
	hspeed = qrd_approach(hspeed, -8, 0.2);
	if (!done && bbox_right < camera_get_view_x(view_camera[0]))
	{
		done = true;
		qrd_show_info(global.boss_victory.title, global.boss_victory.text,
			"Registros coletados: " + string(qrd_collected_count()) + "/" + string(QRD_INFO_COUNT), true);
	}
}
else
{
	x = xstart + random_range(-6, 6);
	y = ystart + random_range(-6, 6);
}
