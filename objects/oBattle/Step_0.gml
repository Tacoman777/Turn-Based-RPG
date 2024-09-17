battleState();

//Cursor Controls
if (cursor.active) {
	with (cursor) {
		//input
		var _keyUp = keyboard_check_pressed(vk_up);
		var _keyDown = keyboard_check_pressed(vk_down);
		var _keyLeft = keyboard_check_pressed(vk_left);
		var _keyRight = keyboard_check_pressed(vk_right);
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
}