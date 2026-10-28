//End Step: Luma's shots hit the cat (before oBullet's End Draw wall check)
if (dead) exit;
with (oBullet) if (place_meeting(x, y, other))
{
	other.hp -= 1;
	other.flash = 1;
	other.shake = 2;
	instance_destroy();
}
