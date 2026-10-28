//Post-Draw: the frame is complete, save the requested screenshot
if (pending_shot != "")
{
	//screen_save reads the front buffer under D3D11 (black), so save the game's own surface
	surface_save(application_surface, "qrdtest_" + pending_shot + ".png");
	log("screenshot " + pending_shot);
	pending_shot = "";
}
