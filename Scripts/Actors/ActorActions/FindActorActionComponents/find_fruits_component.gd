extends BaseFindComponent

class_name FindFruitsComponent

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

## If this is not null or empty, then used this to filter fruits by name. "Fruit Name", "fruitname" are the same
@export var filter_fruit_name : String

func set_brain_key_to_store():
	brain_key_to_store = "FruitsInMemory"

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
	var fruits : Array[Fruit];
	
	match seach_area:
		SeachArea.CARDINAL:
			to_seach = MovementUtil.get_cardinal_movements_for_pos(pos)
		SeachArea.SURROUNDING:
			to_seach = MovementUtil.get_surrounding_movements_for_pos(pos)
		SeachArea.KNIGHT:
			to_seach = MovementUtil.get_knight_movements_for_pos(pos)
		SeachArea.ALL:
			fruits = actor.level_manager.fruits;
		_:
			fruits = [];
	
	if !to_seach.is_empty():
		for fruit in actor.level_manager.fruits:
			if to_seach.has(fruit.board_position):
				fruits.append(fruit);
	
	if !can_be_self and actor is Fruit:
		fruits.erase(actor);
	
	if filter_fruit_name == null or filter_fruit_name.is_empty():
		return fruits;
	
	var filtered_fruits : Array[Fruit] = []
	for fruit in fruits:
		var fruit_name_normalized = fruit.l_fruit_resource.fruit_name.to_lower().replace(" ", "");
		var filter_fruit_name_normalized = filter_fruit_name.to_lower().replace(" ","");
		
		if fruit_name_normalized == filter_fruit_name_normalized:
			filtered_fruits.append(fruit);
	
	return filtered_fruits;
	
