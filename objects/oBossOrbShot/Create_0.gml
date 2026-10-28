//A ghost thrown at Luma (reference obj_top_tiro): flies straight at where she was, breaks on walls
direction = instance_exists(oPlayer) ? point_direction(x, y, oPlayer.x, oPlayer.y) : 180;
speed = 6;
angle2 = direction;
angle3 = direction;
