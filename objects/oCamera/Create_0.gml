/// @description Set up Camera
cam = view_camera[0];
follow = oPlayer;
view_w_half = camera_get_view_width(cam) * 0.5;
view_h_half = camera_get_view_height(cam) * 0.5;
xTo = xstart;
yTo = ystart;
look = 0; //horizontal look-ahead, eases toward the direction the player faces
snap = true; //jump straight to the player on the first step (room start / respawn)

//"follow" style (rTuneis, from the reference): look-ahead that builds up in the facing direction,
//up/down look while the keys are held, 0.125 smoothing on both axes, and screen shake on damage
style = qrd_profile(room).cam;
plusx = 0;
plusy = 0;
shake = 0;
//Arena lock { x, y, range } set by the boss (rChefe): stays on the arena, sliding only "range" px sideways
global.cam_lock = undefined;

//Parallax background layers (optional - only used in rooms that define them)
//The layer's room y is treated as its position on screen when the camera is at the bottom of the room
//(for a room exactly one screen tall this is the same as its room y)
parallax_layers = [];
var _names = ["FarBackground", "MidBackground", "NearBackground"];
var _factors = [0.15, 0.35, 0.60];
//How far each layer moves down the screen when the ground is out of view (high up in tall rooms),
//so the hills always reach the bottom of the screen instead of leaving a band of empty sky
var _lift = [0, 154, 288];
for (var i = 0; i < array_length(_names); i++) {
	if (layer_exists(_names[i])) {
		var _id = layer_get_id(_names[i]);
		array_push(parallax_layers, { id: _id, factor: _factors[i], baseX: layer_get_x(_id), baseY: layer_get_y(_id), lift: _lift[i] });
	}
}
