extends BaseGetDataComponent

class_name GetSnakeDataComponent

enum DataField {
	HEAD_POSITION,
	TAIL_POSITION,
	SIZE,
	EXPECTED_SIZE,
}

@export var data_field : DataField



func set_brain_key_to_store():
	if has_custom_key_value():
		brain_key_to_store = custom_key_value;
		return
	
	match data_field:
		DataField.HEAD_POSITION, DataField.TAIL_POSITION:
			brain_key_to_store = "SnakeBoardPositionMemory"
		DataField.SIZE:
			brain_key_to_store = "SnakeSizeMemory"
		DataField.EXPECTED_SIZE:
			brain_key_to_store = "SnakeExpectedSizeMemory"

func can_do_action() -> bool:
	if !actor.brain.has_brain_key("SnakeInMemory"):
		return false;
	
	var snake = actor.brain.get_from_brain("SnakeInMemory");
	
	if snake is not Snake:
		return false;
	
	if !is_instance_valid(snake):
		return false
	
	return true;

func get_data():
	var snake : Snake = actor.brain.get_from_brain("SnakeInMemory");
	
	match data_field:
		DataField.HEAD_POSITION:
			return snake.head.pos
		DataField.TAIL_POSITION:
			return snake.tail.pos
		DataField.SIZE:
			return snake.body_size
		DataField.EXPECTED_SIZE:
			return snake.expected_size
