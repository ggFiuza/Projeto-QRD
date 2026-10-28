//Saw launcher: counts "offset" down by 2 per frame and fires an oTunSawMove in direction "dir"
//each time it passes -16 (offset 160 = one saw every 88 frames). Set by the instance creation code.
offset = 160;
spawn_offset = 160;
dir = 180;

image_speed = 0;
image_index = 1;
