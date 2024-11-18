collisionMap = layer_tilemap_get_id(layer_get_id("Collision"));

xSpeed = 0;
ySpeed = 0;
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

// Check if Player x and y have been set already
// Sets player spawn location to the desired x and y 
if (variable_global_exists("targetX") && global.targetX != -1) {
	x = global.targetX;
	y = global.targetY;
	direction = global.targetDirection;
}


// Room Transition no like code below this line
// Probably because bro sets x and y 

// Save Code
//ini_open("Save.ini");
//var obj = ini_read_string("player_pos", "object", "");
//x = ini_read_real("player_pos", "x", 192);
//y = ini_read_real("player_pos", "y", 224);
//if obj != ""
//{
//switch(obj)
//	{
//	case "obj_Player": instance_create(xx, yy, obj_Player); break;
//	// add more cases for each object
//	} 
//}

//ini_close();
