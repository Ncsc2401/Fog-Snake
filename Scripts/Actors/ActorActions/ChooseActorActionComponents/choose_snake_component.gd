extends BaseChooseComponent

class_name ChooseSnakeComponent

enum ChooseBy {
	FARTHEST_BY_BOARD,
	CLOSEST_BY_BOARD,
	RANDOM
}

enum RelativeTo {
	SELF,
	FRUIT,
	ENEMY,
	SNAKE
}

@export var choose_by : ChooseBy;
@export var relative_to : RelativeTo;

func set_brain_key_to_store():
	brain_key_to_store = "SnakeInMemory"

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
	
	if !actor.brain.has_brain_key("SnakesInMemory"):
		return false
	
	if actor.brain.get_from_brain_array("SnakesInMemory").is_empty():
		return false
	
	return true

func choose():
	var snakes_in_memory = actor.brain.get_from_brain_array("SnakesInMemory");
	
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
			return get_farthest_snake_by_board(snakes_in_memory, pos)
		ChooseBy.CLOSEST_BY_BOARD:
			return get_closest_snake_by_board(snakes_in_memory, pos);
		ChooseBy.RANDOM:
			return get_random_snake(snakes_in_memory);

func get_farthest_snake_by_board(snakes_in_memory : Array, reference_pos : Vector2i):
	var farthest_snake = snakes_in_memory[0];
	var maximum_distance : float = farthest_snake.head.pos.distance_to(reference_pos);
	
	for snake in snakes_in_memory:
		var distance = snake.head.pos.distance_to(reference_pos)
		if distance > maximum_distance:
			maximum_distance = distance;
			farthest_snake = snake;
	
	return farthest_snake;

func get_closest_snake_by_board(snakes_in_memory : Array, reference_pos : Vector2i):
	var closest_snake = snakes_in_memory[0];
	var minimum_distance : float = closest_snake.head.pos.distance_to(reference_pos);
	
	for snake in snakes_in_memory:
		var distance = snake.head.pos.distance_to(reference_pos)
		if distance < minimum_distance:
			minimum_distance = distance;
			closest_snake = snake;
	
	return closest_snake

func get_random_snake(snakes_in_memory : Array):
	var random_snake = snakes_in_memory.pick_random()
	return random_snake
