draw_sprite_stretched(sBox, 0, x, y, widthFull, heightFull)
draw_set_color(c_white);
draw_set_font(fnM5x7);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var _desc = (description != -1);
var _scrollPush = max(0, hover - (visibleOptionsMax-1));

for (l = 0; l < (visibleOptionsMax + _desc); l++) {
	if (l >= array_length(options)) break;
	draw_set_color(c_white);
	if (l == 0) && (_desc) {
		draw_text(x + xmargin, y + ymargin, description);
	}
	else {
		var _optionToShow = l - _desc + _scrollPush;
		var _str = options[_optionToShow][0];
		if (hover == _optionToShow - _desc) {
			draw_set_color(c_yellow);
		}
		if (options[_optionToShow][3] == false) draw_set_color(c_grey);
		draw_text(x + xmargin, y + ymargin + l * heightLine, _str);
	}
}
draw_sprite(sPointer, 0, x + xmargin, y + ymargin + ((hover - _scrollPush) * heightLine) + 7);
if (visibleOptionsMax < array_length(options)) && (hover < array_length(options)-1) {
	draw_sprite(sDownArrow, 0, x + widthFull * 0.5, y + heightFull - 7);
}