var _cx = (bbox_left + bbox_right) * 0.5;
var _cy = (bbox_top + bbox_bottom) * 0.5;

if (instance_exists(oPlayer) && collision_circle(_cx, _cy, radius, oPlayer, false, true) != noone)
{
	qrd_hurt_player(_cx, 6, -5);
}
