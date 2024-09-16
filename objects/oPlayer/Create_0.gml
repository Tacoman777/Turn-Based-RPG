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
	}else animationEnd = false;
}
