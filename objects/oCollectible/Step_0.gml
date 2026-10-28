//Already collected in this run (e.g. after a respawn): stay gone
if (global.collected[info]) { instance_destroy(); exit; }

bob += 4;

if (instance_exists(oPlayer) && !oPlayer.dead && point_distance(x, y, oPlayer.x, oPlayer.y) < radius)
{
	global.collected[info] = true;
	var _entry = global.info[info];
	qrd_show_info(_entry.title, _entry.text, "Registros coletados: " + string(qrd_collected_count()) + "/" + string(QRD_INFO_COUNT), false);
	instance_destroy();
}
