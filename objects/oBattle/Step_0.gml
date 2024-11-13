battleState();

//Cursor Controls
if (cursor.active) {
	with (cursor) {
		//input
		var _keyUp = keyboard_check_pressed(ord("W"));
		var _keyDown = keyboard_check_pressed(ord("S"));
		var _keyLeft = keyboard_check_pressed(ord("A"));
		var _keyRight = keyboard_check_pressed(ord("D"));
		var _keyToggle = false;
		var _keyConfirm = false;
		var _keyCancel = false;
		confirmDelay++
		if (confirmDelay > 1) {
			_keyConfirm = keyboard_check_pressed(vk_space);
			_keyCancel = keyboard_check_pressed(vk_escape);
			_keyToggle = keyboard_check_pressed(vk_shift);
		}
		var _moveH = _keyRight - _keyLeft;
		var _moveV = _keyDown - _keyUp;
		
		if (_moveH == -1) targetSide = oBattle.partyUnits;
		if (_moveH == 1) targetSide = oBattle.enemyUnits;
		
		//verify target List or check if target dead
		if (targetSide == oBattle.enemyUnits) {
			targetSide = array_filter(targetSide, function(_element, _index) 
			{ 
				return _element.hp > 0;
			});
		}
		
		//move between targets
		if (targetAll == false) { //Single target mode
			if (_moveV == 1) targetIndex++;
			if (_moveV == -1) targetIndex--;
			
			//wrap
			var _targets = array_length(targetSide);
			if (targetIndex < 0) targetIndex = _targets - 1;
			if (targetIndex > (_targets - 1)) targetIndex = 0;
			
			//identify target
			activeTarget = targetSide[targetIndex];
			
			//toggle all mode
			//switch to all mode
			if (activeAction.targetAll == MODE.VARIES) && (_keyToggle) { 
				targetAll = true;
			}
		}
		//target all mode
		else {
			activeTarget = targetSide;
			if(activeAction.targetAll == MODE.VARIES) && (_keyToggle) {
				targetAll = false;
			}
		}
		
		//confirm action
		if (_keyConfirm) {
			with (oBattle) BeginAction(cursor.activeUser, cursor.activeAction, cursor.activeTarget);
			with (oMenu) instance_destroy();
			active = false;
			confirmDelay = 0;
		}
		
		//Cancel and return to menu 
		if (_keyCancel) && (!_keyConfirm) {
			with (oMenu) active = true;
			active = false;
			confirmDelay = 0;
		}
		
	}
}

var kill = keyboard_check_pressed(vk_lalt);
if (kill == true) {
	//instance_destroy();
	room_goto(0);
	//TODO: make room_goto trigger when battle is over
	//summon overworld slimes naturally (so that they can remember if they've been fought)
	//fix joker
	//dont switch mlg's waters around
}

if (keyboard_check(ord("R"))) {
	ini_open("Save.ini");
	ini_section_delete("player_pos");
	ini_close();
}