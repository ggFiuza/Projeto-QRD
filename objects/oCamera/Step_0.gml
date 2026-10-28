/// @description Update camera

if (style == "follow")
{
	//Reference camera, distances doubled for the 32px grid
	if (instance_exists(follow))
	{
		plusx = clamp(plusx + 4 * sign(follow.image_xscale), -96, 96);
		if (follow.key_up) plusy = max(plusy - 4, -96);
		else if (follow.key_down) plusy = min(plusy + 4, 96);
		else plusy = qrd_approach(plusy, 0, 4);
		xTo = follow.x + plusx;
		yTo = follow.y + plusy;
		if (is_struct(global.cam_lock))
		{
			xTo = clamp(xTo, global.cam_lock.x - global.cam_lock.range, global.cam_lock.x + global.cam_lock.range);
			yTo = global.cam_lock.y;
		}
		if (snap)
		{
			x = xTo;
			y = yTo;
		}
	}
	snap = false;

	x += (xTo - x) * 0.125;
	y += (yTo - y) * 0.125;
}
else
{
	//Update destination
	if (instance_exists(follow))
	{
		look = lerp(look, sign(follow.image_xscale) * 70, 0.04);
		xTo = follow.x + look;
		yTo = follow.y;
		//Look ahead while falling so the ground (and any pit) comes into view
		if (variable_instance_exists(follow, "vsp")) yTo += clamp(follow.vsp * 16, 0, 200);
		if (snap)
		{
			x = xTo;
			y = yTo;
		}
	}
	snap = false;

	//Update object position
	x += (xTo - x) / 25;
	y += (yTo - y) / 12;
}


x = clamp(x,view_w_half,room_width-view_w_half);
y = clamp(y,view_h_half,room_height-view_h_half);

//Screen shake (only set by profiles with hurt_shake)
var _sx = 0, _sy = 0;
if (shake > 0)
{
	_sx = random_range(-shake / 2, shake / 2);
	_sy = random_range(-shake / 2, shake / 2);
	shake = max(0, shake - 1);
}

//Update camera view
camera_set_view_pos(cam, x-view_w_half+_sx,y-view_h_half+_sy);

//Update parallax background layers
var _camx = camera_get_view_x(cam);
var _camy = camera_get_view_y(cam);
var _camy_max = room_height - camera_get_view_height(cam);
//1 = bottom of the room in view (ground visible), 0 = 352px or more above it
var _t = clamp((_camy - (_camy_max - 352)) / 352, 0, 1);
for (var i = 0; i < array_length(parallax_layers); i++) {
	var _p = parallax_layers[i];
	layer_x(_p.id, _p.baseX + _camx * (1 - _p.factor));
	//Vertically the layers stay on screen: baseY near the ground, lowered by "lift" when high up
	layer_y(_p.id, _camy + _p.baseY + _p.lift * (1 - _t));
}
