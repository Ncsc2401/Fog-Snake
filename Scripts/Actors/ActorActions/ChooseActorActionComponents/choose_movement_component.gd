extends BaseChooseComponent

class_name ChooseMovementComponent

enum ChooseBy {
	FARTHEST_BY_BOARD,
	CLOSEST_BY_BOARD,
	RANDOM,
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
	brain_key_to_store = ActorBrain.NEXT_BOARD_MOVEMENT

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
			if !actor.brain.has_brain_key("SnakeBoardPositionMemory"):
				return false;
	
	if !actor.brain.has_brain_key(ActorBrain.POSSIBLE_BOARD_MOVEMENTS):
		return false
	
	if actor.brain.get_from_brain_array(ActorBrain.POSSIBLE_BOARD_MOVEMENTS).is_empty():
		return false
	
	return true

func choose():
	var movements_in_memory = actor.brain.get_from_brain_array(ActorBrain.POSSIBLE_BOARD_MOVEMENTS);
	
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
			return get_farthest_movement_by_board(movements_in_memory, pos)
		ChooseBy.CLOSEST_BY_BOARD:
			return get_closest_movement_by_board(movements_in_memory, pos);
		ChooseBy.RANDOM:
			return get_random_movement(movements_in_memory);

func get_farthest_movement_by_board(movements_in_memory : Array, reference_pos : Vector2i):
	var farthest_movement : Vector2i = movements_in_memory[0];
	var maximum_distance : float = farthest_movement.distance_to(reference_pos);
	
	for movement in movements_in_memory:
		var distance = movement.distance_to(reference_pos)
		if distance > maximum_distance:
			maximum_distance = distance;
			farthest_movement = movement;
	
	return farthest_movement;

func get_closest_movement_by_board(movements_in_memory : Array, reference_pos : Vector2i):
	var closest_movement : Vector2i = movements_in_memory[0];
	var minimum_distance : float = closest_movement.distance_to(reference_pos);
	
	for movement in movements_in_memory:
		var distance = movement.distance_to(reference_pos)
		if distance < minimum_distance:
			minimum_distance = distance;
			closest_movement = movement;
	
	return closest_movement

func get_random_movement(movements_in_memory : Array):
	var random_movement = movements_in_memory.pick_random()
	return random_movement
