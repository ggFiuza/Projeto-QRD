//Fin and tail swing after the body (3 deg per frame, like the reference)
angle2 += clamp(angle_difference(direction, angle2), -3, 3);
angle3 += clamp(angle_difference(angle2, angle3), -3, 3);

if (collision_circle(x, y, 9, oPlayer, false, true) != noone) qrd_hurt_player(x, 6, -5);

if (place_meeting(x, y, oWall) || x < -64 || x > room_width + 64 || y < -64 || y > room_height + 64) instance_destroy();
