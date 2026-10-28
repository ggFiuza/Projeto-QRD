if (!instance_exists(oBossCat) || oBossCat.dead) { instance_destroy(); exit; }

t -= (oBossCat.hp < oBossCat.hp_max / 2 && oBossCat.state == 1) ? 1 : 2;
if (t <= 0)
{
	t = 160;
	with (instance_create_layer(x, y, layer, oBossBigShot)) hspeed = -4;
}
