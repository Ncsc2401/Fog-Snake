extends BaseChooseComponent

class_name ChooseEnemyComponent

enum ChooseBy {
	FARTHEST_BY_BOARD,
	CLOSEST_BY_BOARD,
	RANDOM,
	BY_NAME
}

enum RelativeTo {
	SELF,
	FRUIT,
	ENEMY,
	SNAKE
}

@export var choose_by : ChooseBy;
@export var relative_to : RelativeTo;

## Used to Filter enemies by name, only used if choose_by == BY_NAME. 
## "Enemy Name" is the same as "enemyname"
@export var filter_enemy_name : String;

func set_brain_key_to_store():
	brain_key_to_store = "EnemyInMemory"

func can_do_action() -> bool:
	match relative_to:
		RelativeTo.SELF:
			pass
		RelativeTo.FRUIT:
			if !actor.brain.has_brain_key("FruitBoardPositionMemory"):
				return false;
		RelativeTo.ENEMY:
			if !actor.brain.has_brain_key("EnemyBoardPositionMemory"):
				return false;
		RelativeTo.SNAKE:
			if !actor.brain.has_brain_key("FruitBoardPositionMemory"):
				return false;
	
	if !actor.brain.has_brain_key("EnemiesInMemory"):
		return false
	
	if actor.brain.get_from_brain_array("EnemiesInMemory").is_empty():
		return false
	
	return true

func choose():
	var enemies_in_memory = actor.brain.get_from_brain_array("EnemiesInMemory");
	
	var pos : Vector2i;
	match relative_to:
		RelativeTo.SELF:
			pos = actor.board_position;
		RelativeTo.FRUIT:
			pos = actor.brain.get_from_brain_vector2i("FruitBoardPositionMemory")
		RelativeTo.ENEMY:
			pos = actor.brain.get_from_brain_vector2i("EnemyBoardPositionMemory")
		RelativeTo.SNAKE:
			pos = actor.brain.get_from_brain_vector2i("SnakeBoardPositionMemory")
		
	match choose_by:
		ChooseBy.FARTHEST_BY_BOARD:
			return get_farthest_enemy_by_board(enemies_in_memory, pos)
		ChooseBy.CLOSEST_BY_BOARD:
			return get_closest_enemy_by_board(enemies_in_memory, pos);
		ChooseBy.RANDOM:
			return get_random_enemy(enemies_in_memory);
		ChooseBy.BY_NAME:
			return get_enemy_by_name(enemies_in_memory);

func get_farthest_enemy_by_board(enemies_in_memory : Array, reference_pos : Vector2i):
	var farthest_enemy : Enemy = enemies_in_memory[0];
	var maximum_distance : float = farthest_enemy.board_position.distance_to(reference_pos);
	
	for enemy in enemies_in_memory:
		var distance = enemy.board_position.distance_to(reference_pos)
		if distance > maximum_distance:
			maximum_distance = distance;
			farthest_enemy = enemy;
	
	return farthest_enemy;

func get_closest_enemy_by_board(enemies_in_memory : Array, reference_pos : Vector2i):
	var closest_enemy : Enemy = enemies_in_memory[0];
	var minimum_distance : float = closest_enemy.board_position.distance_to(reference_pos);
	
	for enemy in enemies_in_memory:
		var distance = enemy.board_position.distance_to(reference_pos)
		if distance < minimum_distance:
			minimum_distance = distance;
			closest_enemy = enemy;
	
	return closest_enemy

func get_random_enemy(enemies_in_memory : Array):
	var random_enemy = enemies_in_memory.pick_random()
	return random_enemy

func get_enemy_by_name(enemies_in_memory : Array):
	var normalized_filter_enemy_name = filter_enemy_name.to_lower().replace(" ", "");
	for enemy in enemies_in_memory:
		var normalized_enemy_name = enemy.l_enemy_resource.enemy_name.to_lower().replace(" ", "")
		
		if normalized_enemy_name == normalized_filter_enemy_name:
			return enemy;
		
	return null;
