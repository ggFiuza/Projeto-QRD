//Arm, blade, hub
draw_sprite_ext(sTunSawNode, 0, xstart, ystart, orbit_radius / sprite_get_width(sTunSawNode), 1, point_direction(xstart, ystart, x, y), c_white, 1);
draw_self();
draw_sprite(sTunSawCenter, 0, xstart, ystart);
