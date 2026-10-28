if (life > 0)
{
	life--;
	if (life == 0) { impact = false; instance_destroy(); }
}
