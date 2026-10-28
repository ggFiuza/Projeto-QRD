draw_self();
if (lit)
{
	draw_sprite(sChefeStatueFire, image_index, x + oBossCat.shake_draw, y);
	if (oBossCat.flash > 0) draw_sprite(sChefeStatueGlow, 0, x, y);
}
