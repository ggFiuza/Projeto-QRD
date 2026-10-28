if (place_meeting(x,y,oWall)) instance_destroy();

//Bullets that leave the room are never coming back
else if (x < -64) || (x > room_width + 64) || (y < -64) || (y > room_height + 64) { impact = false; instance_destroy(); }
