var _cam = view_camera[0];
var _vx = camera_get_view_x(_cam);
var _vy = camera_get_view_y(_cam);
var _w = camera_get_view_width(_cam);
var _h = camera_get_view_height(_cam);
if (!surface_exists(surf)) surf = surface_create(_w, _h);

surface_set_target(surf);
draw_clear(dark_colour);
gpu_set_blendmode(bm_subtract);
with (oPlayer) if (!dead) draw_sprite(sChefeLightBig, 0, x - _vx, y - _vy);
with (oDead) draw_sprite(sChefeLightBig, 0, x - _vx, y - _vy);
with (oBossIntro) draw_sprite(sChefeLight, 0, x - _vx, y - _vy);
with (oBullet) draw_sprite_ext(sChefeLight, 0, x - _vx, y - _vy, 0.5, 0.5, 0, c_white, 1);
gpu_set_blendmode(bm_normal);
surface_reset_target();

draw_surface(surf, _vx, _vy);
