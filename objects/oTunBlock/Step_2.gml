//End Step: runs before oBullet's End Draw check, which would otherwise just delete the bullet on the wall
var _b = instance_place(x, y, oBullet);
if (_b != noone)
{
	with (_b) instance_destroy();
	repeat (4)
	{
		with (instance_create_depth(x + 16 + random_range(-12, 12), y + 16 + random_range(-12, 12), depth - 1, oPuff)) hs = random_range(-1.5, 1.5);
	}
	instance_destroy();
}
