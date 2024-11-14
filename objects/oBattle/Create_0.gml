  instance_deactivate_all(true);
 
 
units = [];
turn = 0;
turnCount = 0;
roundCount = 0;
battleWaitTimeFrames = 30;
battleWaitTimeRemaining = 0;
battleText = "";
currentUser = noone; 
currentAction = -1;
currentTargets = noone;
unitTurnOrder = [];
unitRenderOrder = [];

//Targeting cursor maker
cursor = {
	activeUser : noone,
	activeTarget : noone,
	activeAction : -1,
	targetSide : -1,
	targetIndex : 0,
	targetAll : false,
	confirmDelay : 0,
	active : false
};



 //Enemy Maker
 for(var i = 0; i < array_length(enemies); i++) {
	enemyUnits[i] = instance_create_depth(x+250+(i*10), y+68+(i*20), depth-10, oBattleUnitEnemy, enemies[i]);
	array_push(units, enemyUnits[i]);
	
 }
 
 //Party Maker
 for(var i = 0; i < array_length(global.party); i++) {
	partyUnits[i] = instance_create_depth(x+70-(i*10), y+68+(i*15), depth-10, oBattleUnitPC, global.party[i]);
	array_push(units, partyUnits[i]);

}

//Shuffle turn order
unitTurnOrder = array_shuffle(units);

//Get render order
RefreshRenderOrder = function() {
	unitRenderOrder = [];
	array_copy(unitRenderOrder,0,units,0,array_length(units))
	array_sort(unitRenderOrder,function(_1, _2) {
		return _1.y - _2.y;
	});
	
}
RefreshRenderOrder();

function BattleStateSelectAction() {
	
	if (!instance_exists(oMenu)) {
		
		//Get Current unit
		var _unit = unitTurnOrder[turn];
	
		//is the unit dead or unable to act?
		if (!instance_exists(_unit)) || (_unit.hp <= 0) {
			battleState = BattleStateVictoryCheck;
			exit;
		}
	
		//Select an action to perform
		//BeginAction(_unit.id, global.actionLibrary.attack, _unit.id);
	
	
		//if unit is player controlled:
		if (_unit.object_index == oBattleUnitPC) {
			//Compile the action menu
			var _menuOptions = [];
			var _subMenus = {};
			
			var _actionList = _unit.actions;
			
			for (var i = 0; i < array_length(_actionList); i++) {
				var _action = _actionList[i];
				var _available = true; //mp cost check here later
				var _nameAndCount = _action.name; //item count add later for if item
				if(_action.subMenu == -1) {
					array_push(_menuOptions, [_nameAndCount, MenuSelectAction, [_unit, _action], _available]);
					
				}
				else {
					//create or add to a submenu
					if (is_undefined(_subMenus[$ _action.subMenu])) {
						variable_struct_set(_subMenus, _action.subMenu, [[_nameAndCount, MenuSelectAction, [_unit, _action], _available]]);
					}
					else {
						array_push(_subMenus[$ _action.subMenu], [_nameAndCount, MenuSelectAction, [_unit, _action], _available]);
					}
				}
				
			
			}
			
			//turn sub menus into an array
			var _subMenusArray = variable_struct_get_names(_subMenus);
			for (var i = 0; i < array_length(_subMenusArray); i++) {
				//sort submenu if needed
				//(here)
					
				//add back option to submenu
				array_push(_subMenus[$ _subMenusArray[i]], ["Back", MenuGoBack, -1, true]);
				//add submenu into main menu
				array_push(_menuOptions, [_subMenusArray[i], SubMenu, [_subMenus[$ _subMenusArray[i]]], true]);
			}
			
			
			//4th empty is an optional description
			Menu(x+10, y+110, _menuOptions, , 74, 60);
		}
		else {
			//if unit is AI controlled:
			var _enemyAction = _unit.AIscript();
			if (_enemyAction != -1) BeginAction(_unit.id, _enemyAction[0], _enemyAction[1]);
		}
	}
}

function BeginAction(_user, _action, _targets) {
	currentUser = _user;
	currentAction = _action;
	currentTargets = _targets;
	battleText = string_ext(_action.description, [_user.name]);
	if (!is_array(currentTargets)) currentTargets = [currentTargets];
	battleWaitTimeRemaining = battleWaitTimeFrames;
	with (_user)
	{
		acting = true;
		//play user animation if it is defined for that action, and that user
		if (!is_undefined(_action[$ "userAnimation"])) && (!is_undefined(_user.sprites[$ _action.userAnimation])) {
			sprite_index = sprites[$ _action.userAnimation];
			image_index = 0;
		}
	}
	battleState = BattleStatePerformAction;
}

function BattleStatePerformAction() {
	
	//if animation etc is still playing
	if (currentUser.acting) {
		
		// Checks if index exceeds frame count
		// and when it ends, perform action effect if it exists
		if (currentUser.image_index >= currentUser.image_number -1) {
			with (currentUser) {
				sprite_index = sprites.idle;
				image_index = 0;
				acting = false;
			}
		
			// Check if action has an effect
			if (variable_struct_exists(currentAction, "effectSprite")) {
			
				// Checks if effect is on each target or screenwide
				// by checking if MODE is always or varies with one target
				// Can give attacks/spells dif animation for single target or AOE
				if (currentAction.effectOnTarget == MODE.ALWAYS) || ( (currentAction.effectOnTarget == MODE.VARIES) && (array_length(currentTargets) <= 1 )) {
				
					// Plays effect on each target and creates oBattleEffect at each target
					for (var i = 0; i < array_length(currentTargets); i++) {
						instance_create_depth(currentTargets[i].x,currentTargets[i].y,currentTargets[i].depth-1,oBattleEffect,{sprite_index : currentAction.effectSprite});
					}
				}
				else { 
					//play it at 0,0
					var _effectSprite = currentAction.effectSprite
				
					// If not playing on targets Checks for no target sprites for the action
					if (variable_struct_exists(currentAction, "effectSpriteNoTarget")) _effectSprite = currentAction.effectSpriteNoTarget;
				
					// Creates instance of oBattleEffect at the room position of the Battle Object
					instance_create_depth(x,y,depth-100,oBattleEffect,{sprite_index : _effectSprite});
				}
			}
			// Attack do damage here
			currentAction.func(currentUser, currentTargets);
		}
	}
	// wait for delay and then end the turn
	else {
		// When unit is done acting and no battle effect is playing
		// moves to victorycheck after delay time becomes zero
		if (!instance_exists(oBattleEffect)) {
			battleWaitTimeRemaining--
			if (battleWaitTimeRemaining == 0) {
				battleState = BattleStateVictoryCheck;
			}
		}
	}
}

function BattleStateVictoryCheck() {
	
	//Checks if there are still enemies left
	var allEnemiesDead = true;
	for(var i = 0; i < array_length(enemyUnits); i++) {
		var _enemy = enemyUnits[i];
		if (_enemy.hp > 0) {
			allEnemiesDead = false;	
		}
	}
	if(allEnemiesDead == true) {
		instance_activate_all();
		instance_destroy();
	}
	//Checks if party is alive
	var allPartyDead = true;
	for(var i = 0; i < array_length(enemyUnits); i++) {
		var _party = partyUnits[i];
		if (_party.hp > 0) {
			allPartyDead = false;	
		}
	}
	if(allPartyDead == true) {
		room_goto(0); // fix later
	}
	
	
	
	
	battleState = BattleStateTurnProgression;
}

function BattleStateTurnProgression() {
	battleText = ""; //reset battleText
	turnCount++;
	turn++;
	// Loop turns
	// When Last unit goes resets back to 1st unit
	if(turn > array_length(unitTurnOrder) - 1) {
		turn = 0;
		roundCount++;
	}
	battleState = BattleStateSelectAction;
}

battleState = BattleStateSelectAction;


