extends BaseGetDataComponent

class_name GetFruitDataComponent

enum DataField {
	BOARD_POSITION,
	POINTS,
	SIZE_INCREASE,
	FRUIT_NAME,
}

@export var data_field : DataField

func set_brain_key_to_store():
	if has_custom_key_value():
		brain_key_to_store = custom_key_value;
		return
	
	match data_field:
		DataField.BOARD_POSITION:
			brain_key_to_store = "FruitBoardPositionMemory"
		DataField.POINTS:
			brain_key_to_store = "FruitPointsMemory"
		DataField.SIZE_INCREASE:
			brain_key_to_store = "FruitSizeIncreaseMemory"
		DataField.FRUIT_NAME:
			brain_key_to_store = "FruitNameMemory"

func can_do_action() -> bool:
	if !actor.brain.has_brain_key("FruitInMemory"):
		return false;
	
	var fruit = actor.brain.get_from_brain("FruitInMemory");
	
	if fruit is not Fruit:
		return false;
	
	if !is_instance_valid(fruit):
		return false
	
	return true;

func get_data():
	var fruit : Fruit = actor.brain.get_from_brain("FruitInMemory");
	
	match data_field:
		DataField.BOARD_POSITION:
			return fruit.board_position
		DataField.POINTS:
			return fruit.l_fruit_resource.points
		DataField.SIZE_INCREASE:
			return fruit.l_fruit_resource.size_increase
		DataField.FRUIT_NAME:
			return fruit.l_fruit_resource.fruit_name;
