spdWalk = 3;
animIndex = 0;

function FourDirectionAnimate() {
	//Update Sprite
	var _animLength = sprite_get_number(sprite_index) / 4;
	image_index = animIndex + (((direction div 90) mod 4) * _animLength);
	animIndex += sprite_get_speed(sprite_index) / 60;

	//If animation would loop on next game step
	if (animIndex >= _animLength)
	{
		animationEnd = true;	
		animIndex -= _animLength;
	} else animationEnd = false;
}

ini_open("Save.ini");
var obj = ini_read_string("player_pos", "object", "");
x = ini_read_real("player_pos", "x", 192);
y = ini_read_real("player_pos", "y", 224);
if obj != ""
{
switch(obj)
	{
	case "obj_Player": instance_create(xx, yy, obj_Player); break;
	// add more cases for each object
	} 
}

ini_close();
