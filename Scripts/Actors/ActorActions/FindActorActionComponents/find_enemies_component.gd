extends BaseFindComponent

class_name FindEnemiesComponent

enum SeachArea {
	CARDINAL,
	KNIGHT,
	SURROUNDING,
	ALL,
}

enum RelativeTo {
	SELF,
	FRUIT,
	ENEMY,
	SNAKE
}

@export var seach_area : SeachArea = SeachArea.CARDINAL;

@export var relative_to : RelativeTo = RelativeTo.SELF;

@export var can_be_self : bool = false;

## If this is not null or empty, then used this to filter enemies by name. "Enemy Name", "fruitname" are the same
@export var filter_enemy_name : String

func set_brain_key_to_store():
	brain_key_to_store = "EnemiesInMemory"

func can_do_action() -> bool:
	match relative_to:
		RelativeTo.SELF:
			return true;
		RelativeTo.FRUIT:
			return actor.brain.has_brain_key("FruitBoardPositionMemory");
		RelativeTo.SNAKE:
			return actor.brain.has_brain_key("SnakeBoardPositionMemory");
		RelativeTo.ENEMY:
			return actor.brain.has_brain_key("EnemyBoardPositionMemory");
		_:
			return false;

func search() -> Array:
	var pos : Vector2i;
	
	match relative_to:
		RelativeTo.SELF:
			pos = actor.board_position;
		RelativeTo.FRUIT:
			pos = actor.brain.get_from_brain("FruitBoardPositionMemory");
		RelativeTo.SNAKE:
			pos = actor.brain.get_from_brain("SnakeBoardPositionMemory");
		RelativeTo.ENEMY:
			pos = actor.brain.get_from_brain("EnemyBoardPositionMemory");
	
	var to_seach : Array[Vector2i] = [];
	var enemies : Array[Enemy];
	
	match seach_area:
		SeachArea.CARDINAL:
			to_seach = MovementUtil.get_cardinal_movements_for_pos(pos)
		SeachArea.SURROUNDING:
			to_seach = MovementUtil.get_surrounding_movements_for_pos(pos)
		SeachArea.KNIGHT:
			to_seach = MovementUtil.get_knight_movements_for_pos(pos)
		SeachArea.ALL:
			enemies = actor.level_manager.enemies;
		_:
			enemies = [];
	
	if !to_seach.is_empty():
		for enemy in actor.level_manager.enemies:
			if to_seach.has(enemy.board_position):
				enemies.append(enemy);
	
	if !can_be_self and actor is Enemy:
		enemies.erase(actor);
	
	if filter_enemy_name == null or filter_enemy_name.is_empty():
		return enemies;
	
	var filtered_enemies : Array[Enemy] = []
	for enemy in enemies:
		var enemy_name_normalized = enemy.l_enemy_resource.enemy_name.to_lower().replace(" ", "");
		var filter_enemy_name_normalized = filter_enemy_name.to_lower().replace(" ","");
		
		if enemy_name_normalized == filter_enemy_name_normalized:
			filtered_enemies.append(enemy);
	
	return filtered_enemies;
	
