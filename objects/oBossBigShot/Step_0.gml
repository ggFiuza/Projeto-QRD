life--;
if (life <= 0 || instance_exists(oBossDeath))
{
	repeat (2) instance_create_layer(x, y, layer, oBossFx);
	instance_destroy();
	exit;
}
if (collision_circle(x, y, 16, oPlayer, false, true) != noone) qrd_hurt_player(x, 6, -5);
