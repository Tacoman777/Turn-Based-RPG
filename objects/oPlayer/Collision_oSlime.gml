ini_open("Save.ini");
ini_write_string("player_pos", "object", object_get_name(oPlayer));
ini_write_real("player_pos", "x", x);
ini_write_real("player_pos", "y", y);
ini_close();