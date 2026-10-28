activated = false;

//Stay lit after a respawn if this is the active checkpoint
if (variable_global_exists("checkpoint_room") && global.checkpoint_room == room
	&& global.checkpoint_x == x && global.checkpoint_y == y)
{
	activated = true;
	image_blend = c_lime;
}
