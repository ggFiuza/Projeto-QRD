if (!activated) {
	activated = true;
	image_blend = c_lime;

	global.checkpoint_room = room;
	global.checkpoint_x = x;
	global.checkpoint_y = y;

	// Boss hook: this is where the boss encounter should start.
	// e.g. instance_create_layer(x, y, "Enemy", oBoss); or trigger a room transition here.
}
