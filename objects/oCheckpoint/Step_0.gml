//The flag's mask only covers the pole, so a jump over it could skip the checkpoint.
//Also activate when Luma jumps over the flag (same code as the collision event): only within a
//double jump's height and with nothing solid in between, so walking on a floor above doesn't count.
if (!activated && instance_exists(oPlayer) && !oPlayer.dead
	&& abs(oPlayer.x - x) < 20 && oPlayer.y < y && oPlayer.y > y - 192
	&& !collision_line(x, oPlayer.y, x, y - 1, oWall, false, true))
{
	event_perform(ev_collision, oPlayer);
}
