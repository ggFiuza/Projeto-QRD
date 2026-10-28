offset -= 2;
if (offset <= -16)
{
	with (instance_create_layer(x, y, layer, oTunSawMove))
	{
		direction = other.dir;
		speed = 4;
	}
	offset = spawn_offset;
}
