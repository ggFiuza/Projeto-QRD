//End Step: runs after oPlayer has moved, so the gun never lags a frame behind
if (!instance_exists(oPlayer)) exit;

//Hide and stop firing while the player is dead
visible = !oPlayer.dead;
if (oPlayer.dead) exit;

x = oPlayer.x;
y = oPlayer.y + 23 - 26 * QRD_LUMA_SCALE;   //hand height, follows Luma's drawing scale (y+10 at half scale)


var _phys = oPlayer.phys;
var _keys_aim = (_phys.aim == "keys");

if (_keys_aim)
{
	//4-way aim like the reference: up, down, or the way Luma faces
	if (oPlayer.key_up) image_angle = 90;
	else if (oPlayer.key_down) image_angle = 270;
	else image_angle = (oPlayer.image_xscale < 0) ? 180 : 0;
}
else if(oPlayer.controller == 0)
{
	image_angle = point_direction(x,y,mouse_x,mouse_y);
}
else
{
	var controllerh = gamepad_axis_value(0,gp_axisrh);
	var controllerv = gamepad_axis_value(0,gp_axisrv);
	if (abs(controllerh) > 0.2) || (abs(controllerv) > 0.2)
	{
		controllerangle = point_direction(0,0,controllerh,controllerv);
	}
	image_angle = controllerangle;
}

firingdelay = firingdelay - 1;
recoil = max(0,recoil-1);

var _fire = _keys_aim ? oPlayer.key_fire : (mouse_check_button(mb_left) || gamepad_button_check(0,gp_shoulderrb));
if (_fire && (firingdelay < 0))
{
	recoil = 4;
	firingdelay = _phys.fire_delay;
	with(instance_create_layer(x,y,"Bullet",oBullet))
	{
		speed = _phys.bullet_speed;
		direction = other.image_angle + (_keys_aim ? 0 : random_range(-3,3));
		//Shots along the ground carry half of Luma's running speed (reference behaviour)
		if (_keys_aim && (direction == 0 || direction == 180)) hspeed += oPlayer.hsp / 2;
		image_angle = direction;
		life = _phys.bullet_life;
	}
}

x = x - lengthdir_x(recoil,image_angle);
y = y - lengthdir_y(recoil,image_angle);

if (image_angle > 90) && (image_angle < 270)
{
	image_yscale = -QRD_LUMA_SCALE;

}
else
{
	image_yscale = QRD_LUMA_SCALE;
}
