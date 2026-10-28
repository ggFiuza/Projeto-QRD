//End Step: a shot on the lit statue hurts the boss
if (!lit) exit;
with (oBullet) if (place_meeting(x, y, other))
{
	with (oBossCat)
	{
		hp -= 1;
		flash = 1;
		shake = 2;
	}
	instance_destroy();
}
