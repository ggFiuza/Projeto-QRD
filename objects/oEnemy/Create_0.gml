
vsp = 0;
grv = 0.3;
walksp = 3;
hsp = walksp;

hp = 4;
flash = 0;
hitfrom = 0;

//"walker": paces and turns at ledges/walls. "guard" (oEnemyGuard): reference hacker behaviour
behavior = "walker";
think = 0;    //guards re-evaluate every 5 frames, like the reference
alert = false;
rest = 0;     //after losing sight: stand still and look around