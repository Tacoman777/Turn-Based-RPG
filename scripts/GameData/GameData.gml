global.actionLibrary = 
{
	attack :
	{
		name : "Attack",
		description : "{0} attacks!",
		subMenu : -1,
		targetRequired : true,
		targetEnemyByDefault : true,
		targetAll : MODE.NEVER,
		userAnimation : "attack",
		effectSprite : sAttackBonk,
		effectOnTarget : MODE.ALWAYS,
		func : function(_user, _targets) {
			var _damage = ceil(_user.strength + random_range(-_user.strength * 0.25, _user.strength * 0.25));
			BattleChangeHP(_targets[0], -_damage, 0);
		}
	},
	ice :
	{
		name : "Ice",
		description : "{0} casts Ice!",
		subMenu : "Magic",
		mpCost : 4,
		targetRequired : true,
		targetEnemyByDefault : true, //0: party/self, 1: enemy
		targetAll : MODE.VARIES,
		userAnimation : "ice",
		effectSprite : sAttackIce,
		effectOnTarget : MODE.ALWAYS,
		func : function(_user, _targets) {
			//var _damage = irandom_range(10,15);
			//BattleChangeHP(_targets[0], -_damage, 0);
			for (var i = 0; i < array_length(_targets); i++) {
				var _damage = irandom_range(15,20);
				if (array_length(_targets) > 1) _damage = ceil(_damage*0.75);
				BattleChangeHP(_targets[i], -_damage);
			}
			
			
			//BattleChangeMP(_user, -mpCost)
		}
	},
	fire :
	{
		name : "Fire",
		description : "{0} casts Fire!",
		subMenu : "Magic",
		mpCost : 4,
		targetRequired : true,
		targetEnemyByDefault : true, //0: party/self, 1: enemy
		targetAll : MODE.VARIES,
		userAnimation : "fire",
		effectSprite : sAttackFire,
		effectOnTarget : MODE.ALWAYS,
		func : function(_user, _targets) {
			//var _damage = irandom_range(10,15);
			//BattleChangeHP(_targets[0], -_damage, 0);
			for (var i = 0; i < array_length(_targets); i++) {
				var _damage = irandom_range(13,22);
				if (array_length(_targets) > 1) _damage = ceil(_damage*0.75);
				BattleChangeHP(_targets[i], -_damage);
			}
			
			
			//BattleChangeMP(_user, -mpCost)
		}
	},
	truths :
	{
		name : "Myriad Truths",
		description : "{0}: All will be revealed!",
		subMenu : "Magic",
		targetRequired : true,
		targetEnemyByDefault : true,
		targetAll : MODE.ALWAYS,
		userAnimation : "attack",
		effectSprite : sAttackBonk,
		effectOnTarget : MODE.ALWAYS,
		func : function(_user, _targets) {
			var _damage = ceil(_user.strength + random_range(-_user.strength * 100, _user.strength * 1000));
			BattleChangeHP(_targets[0], -_damage, 0);
		}
	}
	
	
}

enum MODE {
	NEVER = 0,
	ALWAYS = 1,
	VARIES = 2
}




//Party data
global.party = 
[
	{
		name: "Lulu",
		hp: 89,
		hpMax: 89,
		mp: 10,
		mpMax: 15,
		strength: 20,
		sprites : { idle: sLuluIdle, attack: sLuluAttack, defend: sLuluDefend, down: sLuluDown},
		actions : [global.actionLibrary.attack, global.actionLibrary.truths]
	}
	,
	{
		name: "Questy",
		hp: 18,
		hpMax: 44,
		mp: 20,
		mpMax: 30,
		strength: 4,
		sprites : { idle: sQuestyIdle, attack: sQuestyCast, ice: sQuestyIce, fire: sQuestyFire, down: sQuestyDown},
		actions : [global.actionLibrary.attack, global.actionLibrary.ice, global.actionLibrary.fire, global.actionLibrary.truths]
	}
]

//Enemy Data
global.enemies =
{
	slimeG: 
	{
		name: "Green Slime",
		hp: 30,
		hpMax: 30,
		mp: 0,
		mpMax: 0,
		strength: 5,
		sprites: { idle: sSlimeG, attack: sSlimeGAttack},
		actions: [global.actionLibrary.attack],
		xpValue : 15,
		AIscript : function()
		{
			//enemy turn ai goes here
			//slime ai attack random party member
			var _action = actions[0];
			
			//removes dead characters from targets
			//Makes new array from old array and includes in new array if true
			var _possibleTargets = array_filter(oBattle.partyUnits, function(_unit, _index) {
				return (_unit.hp > 0);
			});
			//chooses random target from array
			//if no possible targets game will crash
			//victory check will happen before this so its ok
			var _target = _possibleTargets[irandom(array_length(_possibleTargets)-1)];
			return [_action, _target];
		}
	}
	,
	slimeB: 
	{
		name: "Blue Slime",
		hp: 30,
		hpMax: 30,
		mp: 0,
		mpMax: 0,
		strength: 5,
		sprites: { idle: sSlimeB, attack: sSlimeBAttack},
		actions: [global.actionLibrary.attack],
		xpValue : 15,
		AIscript : function()
		{
			//enemy turn ai goes here
			//slime ai attack random party member
			var _action = actions[0];
			
			//removes dead characters from targets
			//Makes new array from old array and includes in new array if true
			var _possibleTargets = array_filter(oBattle.partyUnits, function(_unit, _index) {
				return (_unit.hp > 0);
			});
			//chooses random target from array
			//if no possible targets game will crash
			//victory check will happen before this so its ok
			var _target = _possibleTargets[irandom(array_length(_possibleTargets)-1)];
			return [_action, _target];
		}
	}
	,
	bat: 
	{
		name: "Bat",
		hp: 15,
		hpMax: 15,
		mp: 0,
		mpMax: 0,
		strength: 4,
		sprites: { idle: sBat, attack: sBatAttack},
		actions: [global.actionLibrary.attack],
		xpValue : 18,
		AIscript : function()
		{
			//enemy turn ai goes here
			//bat ai attack random party member
			var _action = actions[0];
			
			//removes dead characters from targets
			//Makes new array from old array and includes in new array if true
			var _possibleTargets = array_filter(oBattle.partyUnits, function(_unit, _index) {
				return (_unit.hp > 0);
			});
			//chooses random target from array
			//if no possible targets game will crash
			//victory check will happen before this so its ok
			var _target = _possibleTargets[irandom(array_length(_possibleTargets)-1)];
			return [_action, _target];
		}
	},
}





