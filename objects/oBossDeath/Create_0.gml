//Ray Cat defeated (reference obj_ray_cat_death): shakes in place, then falls away to the left; the victory panel follows
image_speed = 0.1;   //as in the reference: an "explosion" every 20 frames while it shakes
timer = 150;
falling = false;
done = false;
with (oBossOrb) instance_destroy();
with (oBossOrbShot) instance_destroy();
with (oBossShooter) instance_destroy();
with (oCamera) shake = max(shake, 20);
instance_create_depth(0, 0, -9000, oBossFlash);
