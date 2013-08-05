/*
 *
 * DEMO 1
 *
 * Game area
 *
 */

/*
 * Requires
 */

var globals = require('global');

var gamejs = require('gamejs');
var draw = require('gamejs/draw');
var $v = require('gamejs/utils/vectors');

var war = require('war');


/*
 * Initial members
 */


var cursor_pos = [0,0], cursor_state = globals.CursorState.ALLOWED;

console.log(war.name());


/*
 * Sprite classes
 */

// TODO: take tile-coordinate instead of rect
var Monster = function(rect, id) {

	/*
	 * Monster public members
	 */

	// each monster has a unique id
	this.id = id;

	// call superconstructor (Monster is derived from Sprite)
	Monster.superConstructor.apply(this, arguments);

	// speed varies between (1, 10)
	// naturalSpeedTypes go from VERY_SLOW = 0 to VERY_QUICK = 4
	this.speed = 1 + Math.round(Math.random()) + Math.round(this.naturalSpeedType + (this.naturalSpeedType * Math.random()));

	// moveRange is based on speed and it's between [1,5]
	this.moveRange = Math.max(1, Math.floor(this.speed/2));

	/* VERY_WEAK : 0, WEAK : 1, NORMAL : 2, TOUGH : 3, VERY_TOUGH : 4, GODLIKE : 5 */
	this.hp = Math.round((this.endurance*10)+(this.endurance*10*Math.random()));

	// passive image
	this.image = gamejs.image.load(this.image_name + ".png");

	// rect shows the position and dimensions of monster
	this.rect = new gamejs.Rect(rect, [globals.TILE_SIZE, globals.TILE_SIZE]);

	// destination is used while traveling
	this.destination = [0, 0];

	// monster.position shows the tile monster is currently on
	this.position = war.getTile(rect);


	/*
	 * Private members
	 */


	// state of monster is private, so it won't get changed by accident
	var state = globals.MonsterState.INACTIVE;


	/*
	 *
	 * Monster public functions
	 *
	 */

	/* getDamage returns inflicted pain */
	this.getDamage = function(style) { 
		var damage = 0;
	   	for (var i=0; i<this.damage[style]; i++) {
			damage += 10*Math.random();
		}
		return damage;
	}


	/*
	 * moveTo gets parameter coordinates as tiles [0..globals.TILE_AMOUNT] 
	 * and sets monster to motion (actual movement is done in gMonster.update()
	 */
	this.moveTo = function(rect) {

		var tileState = war.getTileState(rect);
		var dist = war.getDistance(this.position, rect);
		var destination = war.moveTowardsGoal(this.position, rect, this.moveRange);

		if (destination) {
			if (this.getState() !== globals.MonsterState.MOVING_AFTER_ATTACK) {
				war.setTileState(this.position, globals.TileState.EMPTY);
			}
			this.changeState(globals.MonsterState.MOVING);
			this.destination = destination;
		}

		/* note that units turn continues until we get a proper destination 
		 * TODO: or turn is manually skipped */
	}


	/*
	 * moveTowards specific target, not necessarily reaching it
	 * this function only calculates point in the route, actual
	 * moving is done through moveTo(rect)
	 */

	/*
	 * skipTurn means that monster does nothing, and next unit gets activated
	 */
	this.skipTurn = function() {
		this.endTurn();
		console.log("Monster",this.name,this.id,"skipped its turn");
	}

	/*
	 * endTurn makes monster inactive, and tells war that it next units turn
	 */
	this.endTurn = function() {
		this.changeState(globals.MonsterState.INACTIVE);
		war.nextUnit();
	}

	/* activate sets monster as 'active' one on battlefield */
	this.activate = function() {
		console.log(this.name, this.id, "just became active");
		this.image = gamejs.image.load(this.image_name + "_active.png");

		/* if this is computer controlled, it launches its ai sequence */
		if (this.controller === globals.Controller.AI) {
			war.doAI(this);
		}
	}

	/* deactivate passivates the monster */
	this.deactivate = function() {
		console.log(this.name, this.id, "was de-activated");
		this.image = gamejs.image.load(this.image_name + ".png");
	}

	/* this.state needs a getter since it's private */
	this.getState = function() {
		return this.state;
	}

	/* this.changeState calls appropriate methods on changing the state of monster */
	this.changeState = function(newState) { 

		if (this.state === newState)
			return;

		this.state = newState;

		switch (this.state) {
			case globals.MonsterState.INACTIVE:
				this.deactivate();
				break;
			case globals.MonsterState.ACTIVE:
				this.activate();
				break;
			default:
		}
	}

	console.log("Created", this.name, this.id, "(speed:", this.speed, "move:", this.moveRange, "hp:",this.hp,")");

	return this;
};


/*
 * Derivative monster classes
 */


var Orc = function(rect, id) {
	this.image_name = "images/orc";
	this.name = "Orc";
	this.family = "Heroes";

	this.personality = war.randomPersonality([globals.MonsterPersonality.BERSERK,globals.MonsterPersonality.INDIVIDUAL]);
	this.naturalSpeedType = globals.MonsterSpeed.VERY_QUICK;
	this.endurance = globals.MonsterEndurance.VERY_TOUGH;
	this.weapon = globals.WeaponStyle.MELEE;

	this.damage = {};
	this.damage[globals.WeaponStyle.MELEE] = 7;
	this.damage[globals.WeaponStyle.RANGED] = 0;
	this.damage[globals.WeaponStyle.MAGIC] = 0;

	this.controller = globals.Controller.HUMAN;

	Monster.call(this, rect, id);
}

var Octopus = function(rect, id) {
	this.image_name = "images/octopus";
	this.name = "Octo-Monster";
	this.family = "Monsters";

	this.personality = war.randomPersonality([globals.MonsterPersonality.CAREFUL,globals.MonsterPersonality.INDIVIDUAL]);
	this.naturalSpeedType = globals.MonsterSpeed.QUICK;
	this.endurance = globals.MonsterEndurance.WEAK;
	this.weapon = globals.WeaponStyle.MAGIC;

	this.damage = {};
	this.damage[globals.WeaponStyle.MELEE] = 2;
	this.damage[globals.WeaponStyle.RANGED] = 0;
	this.damage[globals.WeaponStyle.MAGIC] = 5;

	this.controller = globals.Controller.HUMAN;

	Monster.call(this, rect, id);
}

var Ground = function(rect) {
	Ground.superConstructor.apply(this, arguments);
	this.image = gamejs.image.load("images/tile.png");

	this.rect = new gamejs.Rect(rect, [globals.TILE_SIZE, globals.TILE_SIZE]);

	return this;
};

// inherit (actually: set prototype)
gamejs.utils.objects.extend(Monster, gamejs.sprite.Sprite);
gamejs.utils.objects.extend(Orc, Monster);
gamejs.utils.objects.extend(Octopus, Monster);

gamejs.utils.objects.extend(Ground, gamejs.sprite.Sprite);


Monster.prototype.update = function(msDuration) {

	if (this.getState() === globals.MonsterState.MOVING) {
		/* get direction to destination from current place */
		var position = [this.rect.left, this.rect.top];
		var goal = [this.destination[0]*globals.TILE_SIZE, this.destination[1]*globals.TILE_SIZE];
		var delta = [0, 0];
		var diff = [Math.abs(goal[0]-position[0]), Math.abs(goal[1]-position[1])];

		/* We launch actual attack only when movement has finished */
		if (position[0] == goal[0] && position[1] == goal[1])
		{
			this.position = this.destination;

			/* if we are on hostile tile, we launch attack */
			if ((war.getTileState(this.position) === globals.TileState.OCCUPIED) && (war.getMonsterAt(this.position).family != this.family)) {
				this.enemy = war.getMonsterAt(this.position);
				this.changeState(globals.MonsterState.ATTACKING);
			}
			/* else, we end turn */
			else {
				war.setTileState(this.position, globals.TileState.OCCUPIED, this.id);
				this.endTurn();
				console.log("Monster",this.name,"finished its journey.");
			}
			return;
		}

		// monster moves speed*30 pixels per second
		var speed = 1+Math.floor((this.speed*20) * (msDuration/1000));

		delta[0] = Math.min(speed, diff[0]);
		delta[1] = Math.min(speed, diff[1]);

		delta[0] = (position[0] > goal[0])? (-delta[0]) : (delta[0]);
		delta[1] = (position[1] > goal[1])? (-delta[1]) : (delta[1]);

		// moveIp, move in place
		this.rect.moveIp(delta[0], delta[1]);
	}
	else if (this.getState() === globals.MonsterState.ATTACKING) {
		
		var result = war.battle(this.id, this.enemy.id);

		/* after melee attack (if both are still alive) we find a new position for attacker */
		if (this.position[0] == this.enemy.position[0] && this.position[1] == this.enemy.position[1]) {
			var newLocation = war.findNewLocation(this.position);
			console.log("New location:",newLocation);
			this.changeState(globals.MonsterState.MOVING_AFTER_ATTACK);
			this.moveTo(newLocation);
		}
		else
			this.endTurn();

	}
};


/*
 *
 * Main function 
 *
 */


function main() {


	/*
	 * Initial screen setup
	 */


	gamejs.display.setMode([globals.CANVAS_WIDTH, globals.CANVAS_HEIGHT]);
	gamejs.display.setCaption("Example Monsters");

	var mainSurface = gamejs.display.getSurface();

	var activeMonster = null;
	var activeMonsterIndex = -1;

	/*
	 * Sprites
	 */


	/* Monsters */

	globals.Monsters = new gamejs.sprite.Group();

	for (var i=0; i < (globals.AMOUNT_OF_MONSTERS); i++)
		globals.Monsters.add(new Orc([i*globals.TILE_SIZE, 0], i));
	for (var i=0; i < (globals.AMOUNT_OF_MONSTERS); i++)
		globals.Monsters.add(new Octopus([i*globals.TILE_SIZE, 9*globals.TILE_SIZE], i+globals.AMOUNT_OF_MONSTERS));

	/* Ground */

	var gGroundTiles = new gamejs.sprite.Group();

	for (var i=0; i<globals.TILE_AMOUNT; i++) {
		for (var j=0; j<globals.TILE_AMOUNT; j++) {
			gGroundTiles.add(new Ground([i*globals.TILE_SIZE, j*globals.TILE_SIZE]));
		}
	}


	/*
	 * Engine initializations
	 */


	war.initUnits();
	war.initTiles();


	/*
	 * Event handling
	 */


	gamejs.onEvent(function(event) {

		/* Mouse movement */
		if (event.type === gamejs.event.MOUSE_MOTION) {
			/* If we are on canvas, draw rectangle on current tile */
			if (mainSurface.rect.collidePoint(event.pos)) {
				cursor_pos = war.getTile(event.pos);

				var dist = war.getDistance(cursor_pos, activeMonster.position);

				if (dist > activeMonster.moveRange) {
					cursor_state = globals.CursorState.DISALLOWED;
				}
				else {
					var monsterInTile = war.getTileState(cursor_pos);
					if (monsterInTile === globals.TileState.OCCUPIED) {
						if (war.getMonsterAt(cursor_pos).family != activeMonster.family)
						cursor_state = globals.CursorState.ATTACK;
					}
					else {
						cursor_state = globals.CursorState.ALLOWED;
					}
				}
			}
		}

		/* Mouse clicking */
		if (event.type === gamejs.event.MOUSE_UP) {
			
			// TODO: make sure only clicks on game area are registered
			// (after status area is implemented, that is)
			if (mainSurface.rect.collidePoint(event.pos)) {

				// if activeMonster's not human controlled, we do nothing
				if (activeMonster.controller !== globals.Controller.HUMAN)
					return;

				// get clicked tile
				var click_pos = war.getTile(event.pos);

				// check its state and distance there
				var tileState = war.getTileState(click_pos);
				var dist = war.getDistance(click_pos, activeMonster.position);

				console.log("Click:", click_pos, "state:", tileState, "dist:", dist);

				activeMonster.moveTo(click_pos);
			}
		}
	});

	
	/*
	 * Main loop
	 */


	/* msDuration = time since last tick() call */
	gamejs.onTick(function(msDuration) {

		if (war.getCurrentUnit() != activeMonsterIndex) {
			activeMonsterIndex = war.getCurrentUnit();
			activeMonster = globals.Monsters.sprites()[activeMonsterIndex];
			activeMonster.changeState(globals.MonsterState.ACTIVE);
		}
		/*
		 * Drawing stuff
		 */

		// update the monsters
		globals.Monsters.update(msDuration);

		// clear
		mainSurface.fill("#efefef");
		
		// draw ground first
		gGroundTiles.draw(mainSurface);

		// then "cursor"
		war.drawCursor(mainSurface, cursor_pos, cursor_state);

		// on top of everything else, monsters
		globals.Monsters.draw(mainSurface);

	});
}


/*
 * Preloads
 */


gamejs.preload(['images/orc.png']);
gamejs.preload(['images/orc_active.png']);
gamejs.preload(['images/octopus.png']);
gamejs.preload(['images/octopus_active.png']);
gamejs.preload(['images/tile.png']);


/* Go! */
gamejs.ready(main);
