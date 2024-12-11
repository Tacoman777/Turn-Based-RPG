var _inputH = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var _inputV = keyboard_check(ord("S")) - keyboard_check(ord("W"));
var _inputD = point_direction(0,0,_inputH,_inputV);
var _inputM = point_distance(0,0,_inputH,_inputV);

xSpeed = lengthdir_x(spdWalk*_inputM,_inputD);
ySpeed = lengthdir_y(spdWalk*_inputM,_inputD);

PlayerCollision();


if (_inputM != 0)
{
	direction = _inputD;	
	image_speed = 1;
}
else
{
	image_speed = 0;
	animIndex = 0;
}

FourDirectionAnimate();

if (keyboard_check(ord("R"))) { // Erase
	ini_open("Save.ini");
	ini_section_delete("player_pos");
	ini_close();
	x = 192;
	y = 224;
}
if (keyboard_check(ord("F"))) { // Save
	ini_open("Save.ini");
	ini_write_string("player_pos", "object", object_get_name(oPlayer));
	ini_write_real("player_pos", "x", x);
	ini_write_real("player_pos", "y", y);
	ini_close();
}
if (keyboard_check(ord("T"))) { // Load
	ini_open("Save.ini");
	var obj = ini_read_string("player_pos", "object", "");
	if obj != ""
	{
	switch(obj)
		{
		case "obj_Player": instance_create(xx, yy, obj_Player); break;
		// add more cases for each object
		} 
	}
	ini_close();
}