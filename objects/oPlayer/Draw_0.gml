//Team's BIG art (80x80) at QRD_LUMA_SCALE (0.5 would be one art pixel per screen pixel with the 2x camera).
//Collision uses sPlayerMask, so the drawing scale does not change the physics.
//Scaled from the feet (46 art px below the origin, 23 world px at half scale) so they stay on the ground
var _s = QRD_LUMA_SCALE;
draw_sprite_ext(sprite_index, image_index, x, y + 23 - 46 * _s, image_xscale * _s, image_yscale * _s, 0, image_blend, image_alpha);
