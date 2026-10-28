pulse = 0;

//New game: forget checkpoints and collected records from a previous run
qrd_reset_run();

//Title scene: Luma runs in place on a straight track while the tunnel parallax and the ground
//scroll past and robots come from the right. Screen = the tunnel view (512x384) at 2x, so the
//tunnel art is drawn at 2x and Luma/shots (BIG art, half scale in game) at 1x.
ground_y = 576;          //top of the track
run_speed = 6;           //track scroll, px per frame
scroll = 0;              //distance run so far

//Luma (sPlayerR/sPlayerA feet are 45px below the origin)
luma_x = 300;
luma_y = ground_y - 45;
luma_vsp = 0;
luma_jumps = 0;
luma_hurt = 0;
fire_delay = 0;

//Demo mode: Luma jumps the robots by herself until someone presses a key
idle = 0;
idle_demo = 300;

enemies = [];
shots = [];
effects = [];
spawn_t = 90;

//Automated playtest (see oQrdTest): only when the QRD_AUTOTEST environment variable is set
if (environment_get_variable("QRD_AUTOTEST") != "" && !instance_exists(oQrdTest)) instance_create_depth(0, 0, 0, oQrdTest);