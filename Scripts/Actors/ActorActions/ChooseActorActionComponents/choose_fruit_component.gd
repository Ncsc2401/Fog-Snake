extends BaseChooseComponent

class_name ChooseFruitComponent

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

## Used to filter fruits by name, only used if choose_by == BY_NAME. 
## "Enemy Name" is the same as "fruitname"
@export var filter_fruit_name : String;

func set_brain_key_to_store():
	brain_key_to_store = "FruitInMemory"

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
	
	if !actor.brain.has_brain_key("FruitsInMemory"):
		return false
	
	if actor.brain.get_from_brain_array("FruitsInMemory").is_empty():
		return false
	
	return true

func choose():
	var fruits_in_memory = actor.brain.get_from_brain_array("FruitsInMemory");
	
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
			return get_farthest_fruit_by_board(fruits_in_memory, pos)
		ChooseBy.CLOSEST_BY_BOARD:
			return get_closest_fruit_by_board(fruits_in_memory, pos);
		ChooseBy.RANDOM:
			return get_random_fruit(fruits_in_memory);
		ChooseBy.BY_NAME:
			return get_fruit_by_name(fruits_in_memory);

func get_farthest_fruit_by_board(fruits_in_memory : Array, reference_pos : Vector2i):
	var farthest_fruit : Fruit = fruits_in_memory[0];
	var maximum_distance : float = farthest_fruit.board_position.distance_to(reference_pos);
	
	for fruit in fruits_in_memory:
		var distance = fruit.board_position.distance_to(reference_pos)
		if distance > maximum_distance:
			maximum_distance = distance;
			farthest_fruit = fruit;
	
	return farthest_fruit;

func get_closest_fruit_by_board(fruits_in_memory : Array, reference_pos : Vector2i):
	var closest_fruit : Fruit = fruits_in_memory[0];
	var minimum_distance : float = closest_fruit.board_position.distance_to(reference_pos);
	
	for fruit in fruits_in_memory:
		var distance = fruit.board_position.distance_to(reference_pos)
		if distance < minimum_distance:
			minimum_distance = distance;
			closest_fruit = fruit;
	
	return closest_fruit

func get_random_fruit(fruits_in_memory : Array):
	var random_fruit = fruits_in_memory.pick_random()
	return random_fruit

func get_fruit_by_name(fruits_in_memory : Array):
	var normalized_filter_fruit_name = ActorBrain.get_normalized_key(filter_fruit_name)
	for fruit in fruits_in_memory:
		var normalized_fruit_name = ActorBrain.get_normalized_key(fruit.l_fruit_resource.fruit_name);
		
		if normalized_fruit_name == normalized_filter_fruit_name:
			return fruit;
		
	return null;
