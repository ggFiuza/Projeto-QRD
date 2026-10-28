if (!instance_exists(oBossCat) || oBossCat.dead) { instance_destroy(); exit; }

var _c = oBossCat;
var _a = number * 70 + _c.spin_angle;
x = _c.x + lengthdir_x(_c.radius * 2, _a);
y = _c.y + lengthdir_y(_c.radius * 2, _a);
face_dir = _a + 90;
angle2 = face_dir - 10;
angle3 = face_dir - 20;

if (collision_circle(x, y, 9, oPlayer, false, true) != noone) qrd_hurt_player(x, 6, -5);
