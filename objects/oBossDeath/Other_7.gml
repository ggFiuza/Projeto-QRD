//Animation End: explosions while it shakes
if (!falling)
{
	with (oCamera) shake = max(shake, 14);
	repeat (3) instance_create_layer(x + random_range(-24, 24), y + random_range(-24, 24), layer, oBossFx);
}
