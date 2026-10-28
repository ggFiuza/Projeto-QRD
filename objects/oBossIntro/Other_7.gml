//Animation End
if (sprite_index == sChefeCatScream)
{
	//After the scream, float straight up from the rail (same rising speed as the reference's emerge)
	sprite_index = sChefeCatEmerge;
	image_index = 0;
	vspeed = -0.8;
}
else if (sprite_index == sChefeCatPop)
{
	//The pop turns into the boss, and the lights come on
	instance_create_layer(x, y, "Boss", oBossCat);
	instance_create_depth(0, 0, -9000, oBossFlash);
	with (oBossDark) instance_destroy();
	with (oCamera) shake = max(shake, 20);
	instance_destroy();
}
