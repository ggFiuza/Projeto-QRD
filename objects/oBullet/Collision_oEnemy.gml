with (other)
{
	hp--;
	flash = 3;
	hitfrom = point_direction(other.x, other.y, x, y);
}

instance_destroy();