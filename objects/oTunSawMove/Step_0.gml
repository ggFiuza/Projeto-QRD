event_inherited();

grace--;
if ((grace <= 0 && place_meeting(x, y, oWall))
	|| x < -64 || x > room_width + 64 || y < -64 || y > room_height + 64)
{
	repeat (3)
	{
		with (instance_create_depth(x + 16 + random_range(-8, 8), y + 16 + random_range(-8, 8), depth - 1, oPuff)) hs = random_range(-1.5, 1.5);
	}
	instance_destroy();
}
