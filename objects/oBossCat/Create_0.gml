//Ray Cat, the last boss of the reference demo (obj_gemaboss there), ported to QRD.
//The state machine, timers and turn speeds are the reference's. Distances (orbit radius, walking
//speed, bobbing) are kept in reference units here and doubled where they are applied (32px grid).
boss_name = "MARIANA";
hp_max = 400;
hp = hp_max;
hp_smooth = hp;

state = 1;          //1 patrol, 2 barrage, 3 fire ghosts one by one, 4 fire all, 5-6 regroup
timer = 1000;
laps = 0;           //bounces between the two oBossBound markers while patrolling
hsp = 0;            //reference px per frame (x2 when moving)
radius = 21;        //orbit radius of the 5 ghosts, reference px
spin = 0;           //extra orbit speed added to the base 2.5 deg/frame
spin_angle = 0;

bob_t = 0;          //gentle up/down floating
yy = y;
alpha = 1;
shake = 0;
shake_draw = 0;
flash = 0;
dead = false;

//The front tile layer slides away when the fight starts (the reference's "Tileset_Scroll")
scroll_speed = 0;
scroll_x = 0;
scroll_tm = layer_tilemap_get_id(layer_get_id("TilesScroll"));

//The arena: camera lock, and the barrage launcher position (reference: 159, 22 px from the arena centre)
arena = instance_find(oBossArena, 0);
shooter_x = arena.x + 318;
shooter_y = arena.y + 44;
global.cam_lock = { x: arena.x, y: arena.y, range: 64 };

spawn_orbs = function()
{
	for (var i = 1; i <= 5; i++) with (instance_create_layer(x, y, layer, oBossOrb)) number = i;
}
//Turn ghost number _n into a shot aimed at Luma
fire_orb = function(_n)
{
	with (oBossOrb) if (number == _n)
	{
		instance_create_layer(x, y, layer, oBossOrbShot);
		instance_destroy();
	}
}
statue_smoke = function()
{
	with (oBossStatue) repeat (3)
		instance_create_layer(x + 162 + random_range(-8, 8), y + 142 + random_range(-8, 8), layer, oBossFx);
}

spawn_orbs();
statue_smoke();
