if (!dead)
{
	//The cat fades out while the ghosts are spread wide
	if (radius < 42) alpha = min(1, alpha + 0.1);
	else alpha = max(0, alpha - 0.1);

	switch (state)
	{
		case 1:   //patrol between the markers; the ghost ring opens after 2 bounces and closes after 6
			if (timer == 999)
			{
				laps = 0;
				x -= 2;
				hsp = -1;
				if (hp < hp_max / 2) instance_create_layer(shooter_x, shooter_y, layer, oBossShooter);
			}
			timer--;
			if (laps == 2)
			{
				if (radius < 63) radius += 0.5;
				if (spin > -2) spin -= 0.05;
			}
			if (laps == 6)
			{
				if (hp < hp_max / 2) with (oBossShooter) instance_destroy();
				if (radius > 21) radius -= 0.5;
				if (spin < 0) spin += 0.05;
			}
			if (laps == 8)
			{
				laps = 0;
				timer = 600;
				state = 2;
				statue_smoke();
			}
			break;

		case 2:   //stand still while the launcher fires
			hsp = 0;
			if (timer == 600) instance_create_layer(shooter_x, shooter_y, layer, oBossShooter);
			if (timer == 0)
			{
				with (oBossShooter) instance_destroy();
				timer = 1000;
				state = 3;
			}
			timer--;
			break;

		case 3:   //spin up, then throw the ghosts at Luma one at a time
			if (image_index >= 15) image_index = 3;
			timer -= 4;
			if (timer < 500) { if (spin > -2.5) spin -= 0.5; }
			else if (spin < 8)
			{
				spin += 0.1;
				sprite_index = sChefeCatSad;
			}
			if (spin == -2.5)
			{
				fire_orb(1);
				for (var i = 2; i <= 5; i++) if (!instance_exists(oBossOrbShot)) fire_orb(i);
				if (!instance_exists(oBossOrbShot) && !instance_exists(oBossOrb))
				{
					state = 4;
					timer = 1000;
				}
			}
			break;

		case 4:   //new ring, then all five at once
			if (sprite_index == sChefeCatSad && image_index >= 15) image_index = 3;
			if (timer == 1000)
			{
				radius = 0;
				spawn_orbs();
			}
			if (spin < 0) spin += 0.25;
			if (radius == 20) timer = 1000;
			if (radius < 21) radius += 0.5;
			if (radius == 21 && spin == 0)
			{
				sprite_index = sChefeCatAttack;
				for (var i = 1; i <= 5; i++) fire_orb(i);
				if (floor(image_index) == 3)
				{
					sprite_index = sChefeCat;
					timer = 1000;
					state = 5;
				}
			}
			timer--;
			break;

		case 5:
			timer = 1000;
			state = 6;
			break;

		case 6:   //regroup, then patrol again
			if (timer == 1000)
			{
				radius = 0;
				spawn_orbs();
				statue_smoke();
			}
			if (spin < 0) spin += 0.25;
			if (radius == 20) timer = 1000;
			if (radius < 21) radius += 0.5;
			if (radius == 21 && spin == 0)
			{
				with (oBossShooter) instance_destroy();
				timer = 1000;
				state = 1;
			}
			timer--;
			break;
	}

	//Bounce off the arena markers (counted once per bounce)
	var _b = instance_place(x, y, oBossBound);
	if (_b != noone && hsp != 0 && sign(hsp) == sign(_b.x - x))
	{
		if (state == 1) laps++;
		hsp = -hsp;
	}

	if (instance_exists(oPlayer)) image_xscale = (x < oPlayer.x) ? 1 : -1;
	spin_angle = (spin_angle + 2.5 + spin) mod 360;
	bob_t = (bob_t + 4) mod 360;
	y = yy + 10 * dsin(bob_t);
	x += hsp * 2;

	if (hp < 0)
	{
		dead = true;
		visible = false;
		instance_create_layer(x, y, layer, oBossDeath);
	}
}

hp_smooth = hp_smooth + (hp - hp_smooth) * 0.025;
shake = qrd_approach(shake, 0, 0.1);
shake_draw = random_range(-shake, shake) * 2;
if (flash > 0) flash--;

//Front tiles slide left (up to 1300 reference px, i.e. 2600 here) and the background with them
scroll_speed = qrd_approach(scroll_speed, -6, 0.025);
scroll_x = max(scroll_x + scroll_speed, -1300);
tilemap_x(scroll_tm, scroll_x * 2);
with (oBossBackground) hsp = other.scroll_speed / 1.5;
if (scroll_x < -1200) with (oBossAcidJet) y = y + ((ystart - 64) - y) * 0.05;
