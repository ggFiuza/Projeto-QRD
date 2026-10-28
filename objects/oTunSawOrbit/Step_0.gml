orbit_angle = (orbit_angle + orbit_speed) mod 360;
x = xstart + lengthdir_x(orbit_radius, orbit_angle);
y = ystart + lengthdir_y(orbit_radius, orbit_angle);

event_inherited();
