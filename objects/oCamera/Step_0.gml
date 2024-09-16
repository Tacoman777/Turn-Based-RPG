/// @description Update camera

//Update destination
if (instance_exists(follow))
{
	xTo = follow.x;
	yTo = follow.y;
}

//Update object position
x += (xTo - x) / 15;
y += (yTo - y) / 15;

//Keep camera center inside room
x = clamp(x,viewWHalf,room_width-viewWHalf);
y = clamp(y,viewHHalf,room_height-viewHHalf);

//Update camera view
camera_set_view_pos(cam,x-viewWHalf,y-viewHHalf);

