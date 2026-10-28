//The big cat statue behind the bridge lights up while Ray Cat patrols (states 1 and 6):
//then shots that hit it also hurt the boss (reference obj_boss_dano)
lit = instance_exists(oBossCat) && !oBossCat.dead && (oBossCat.state == 1 || oBossCat.state == 6);
sprite_index = lit ? sChefeStatue : sChefeStatueOff;
