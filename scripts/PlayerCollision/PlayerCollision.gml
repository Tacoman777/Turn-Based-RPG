function PlayerCollision() {
	var _collision = false;

	//Horizontal Tile Check
	if(tilemap_get_at_pixel(collisionMap, x + xSpeed, y)) {
		x -= x mod 16; //16 = Tile Size
		if(sign(xSpeed) == 1) x += 16 - 1;
		xSpeed = 0;
		_collision = true;
	}
	
	//Horizontal Move 
	x += xSpeed;
	
	//Vertical Tile Check
	if(tilemap_get_at_pixel(collisionMap, x, y + ySpeed)) {
		y -= y mod 16; //16 = Tile Size
		if(sign(ySpeed) == 1) y += 16 - 1;
		ySpeed = 0;
		_collision = true;
	}
	
	//Vertical Move 
	y += ySpeed;





	return _collision;
}
