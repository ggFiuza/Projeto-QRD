pulse++;

if (!used && instance_exists(oPlayer) && !oPlayer.dead
	&& abs(oPlayer.x - x) < 28 && oPlayer.y > y - 110 && oPlayer.y < y)
{
	used = true;
	//After the panel: Luma's monologue (rMonologo), then the boss fight (rChefe); its victory panel returns to the menu
	qrd_show_info(global.ending.title, global.ending.text,
		"Registros coletados: " + string(qrd_collected_count()) + "/" + string(QRD_INFO_COUNT), false, rMonologo);
}
