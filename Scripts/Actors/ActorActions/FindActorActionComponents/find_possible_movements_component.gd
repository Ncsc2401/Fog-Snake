extends BaseFindComponent

class_name FindPossibleMovementsComponent

enum SeachArea {
	CARDINAL,
	KNIGHT,
	SURROUNDING,
	ALL,
	FROM_RELATIVE_MOVEMENTS,
	FROM_MEMORY
}

enum RelativeTo {
	SELF,
	FRUIT,
	ENEMY,
	SNAKE
}

@export var seach_area : SeachArea = SeachArea.CARDINAL;

## Used if seach_area == FROM_RELATIVE_MOVEMENTS
@export var relative_movements : Array[Vector2i];

## Used if seach_area == FROM_MEMORY, must be an array
@export var movements_memory_key : String
@export var relative_to : RelativeTo = RelativeTo.SELF;

func set_brain_key_to_store():
	brain_key_to_store = ActorBrain.POSSIBLE_BOARD_MOVEMENTS;

func can_do_action() -> bool:
	match seach_area:
		SeachArea.FROM_RELATIVE_MOVEMENTS:
			if relative_movements.is_empty():
				return false;
				
		SeachArea.FROM_MEMORY:
			if !actor.brain.has_brain_key(movements_memory_key):
				return false;
			
			var movements_memory = actor.brain.get_from_brain(movements_memory_key);
			if movements_memory is not Array:
				return false;
	
	match relative_to:
		RelativeTo.SELF:
			return true;
		RelativeTo.FRUIT:
			return actor.brain.has_brain_key("FruitBoardPositionMemory");
		RelativeTo.SNAKE:
			return actor.brain.has_brain_key("SnakeBoardPositionMemory");
		RelativeTo.ENEMY:
			return actor.brain.has_brain_key("EnemyBoardPositionMemory")
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
	
	var movements : Array;
	
	match seach_area:
		SeachArea.FROM_MEMORY:
			var vec_elements = []
			var movements_memory = actor.brain.get_from_brain(movements_memory_key);
			
			for movement in movements_memory:
				if movement is Vector2i:
					vec_elements.append(movement);
				elif movement is Vector2:
					vec_elements.append(Vector2i(movement))
			
			movements = vec_elements;
		SeachArea.CARDINAL:
			movements = MovementUtil.get_cardinal_movements_for_pos(pos)
		SeachArea.SURROUNDING:
			movements = MovementUtil.get_surrounding_movements_for_pos(pos)
		SeachArea.KNIGHT:
			movements = MovementUtil.get_knight_movements_for_pos(pos)
		SeachArea.ALL:
			movements = actor.level_manager.get_empty_spaces();
		SeachArea.FROM_RELATIVE_MOVEMENTS:
			movements = MovementUtil.get_movement_for_pos_from_relatives_moves(pos, relative_movements);
		_:
			movements = [];
	
	return movements.filter(func(a):return actor.level_manager.is_space_empty(a));
