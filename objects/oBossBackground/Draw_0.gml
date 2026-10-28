var _cam = view_camera[0];
var _cx = camera_get_view_x(_cam) + camera_get_view_width(_cam) * 0.5;
var _cy = camera_get_view_y(_cam) + camera_get_view_height(_cam) * 0.5;
draw_sprite_tiled(sChefeBack, 0, _cx / 1.5 + x_back, _cy / 1.5);
