draw_set_font(font);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_alpha(image_alpha);
draw_set_color(c_black);

//Text outline but goofy
draw_text(x+1,y,text);
draw_text(x-1,y,text);
draw_text(x,y+1,text);
draw_text(x,y-1,text);
draw_set_color(col);
draw_text(x,y,text);
draw_set_alpha(1.0);
