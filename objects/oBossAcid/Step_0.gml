//Acid (reference obj_insta_death): touching it kills Luma at once
if (instance_exists(oPlayer) && !oPlayer.dead && place_meeting(x, y, oPlayer)) oPlayer.hp = 0;
