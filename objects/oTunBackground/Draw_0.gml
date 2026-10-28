//Tunnel parallax: five tiled planes, farthest first. Same formula as the reference level
//(plane position = camera centre / k), with every distance doubled for the 32px grid.
//On screen each plane scrolls at (1 - 1/k) of the camera speed: ~23% (bk5) to ~33% (bk1).
var _cam = view_camera[0];
var _cx = camera_get_view_x(_cam) + camera_get_view_width(_cam) * 0.5;
var _cy = camera_get_view_y(_cam) + camera_get_view_height(_cam) * 0.5;
var _py = (_cy - 200) / 1.1;

draw_sprite_tiled(sTunBk5, 0, _cx / 1.3, _py);
draw_sprite_tiled(sTunBk4, 0, _cx / 1.35, _py);
draw_sprite_tiled(sTunBk3, 0, _cx / 1.4, _py);
draw_sprite_tiled(sTunBk2, 0, _cx / 1.45, _py);
draw_sprite_tiled(sTunBk1, 0, _cx / 1.5, _py);
