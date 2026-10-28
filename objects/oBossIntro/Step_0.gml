//Luma comes close: scream in place on the rail (the rise starts at the end of the scream, Animation End)
if (sprite_index == sChefeCatLick && instance_exists(oPlayer) && !oPlayer.dead && distance_to_object(oPlayer) < 64)
{
	sprite_index = sChefeCatScream;
	image_index = 0;
}

//Rising from the rail: from here on the camera stays on the arena
if (sprite_index == sChefeCatEmerge || sprite_index == sChefeCatPop)
{
	var _a = instance_find(oBossArena, 0);
	global.cam_lock = { x: _a.x, y: _a.y, range: 64 };
}

//Up at the height of the arena markers: pop
var _b = instance_find(oBossBound, 0);
if (sprite_index == sChefeCatEmerge && _b != noone && y <= _b.bbox_top)
{
	sprite_index = sChefeCatPop;
	image_index = 0;
	vspeed = 0;
	y = _b.bbox_top;
}
