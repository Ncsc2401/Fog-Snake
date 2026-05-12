extends BaseFindComponent

class_name FindSnakesComponent

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

enum CompareWith {
	TAIL,
	HEAD
}

@export var seach_area : SeachArea = SeachArea.CARDINAL;

@export var relative_to : RelativeTo = RelativeTo.SELF;

@export var compare_with : CompareWith = CompareWith.HEAD;

@export var must_be_alive : bool = true;

func set_brain_key_to_store():
	brain_key_to_store = "SnakesInMemory"

func can_do_action() -> bool:
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
	
	var to_seach : Array[Vector2i] = [];
	var snakes : Array[Snake];
	
	match seach_area:
		SeachArea.CARDINAL:
			to_seach = MovementUtil.get_cardinal_movements_for_pos(pos)
		SeachArea.SURROUNDING:
			to_seach = MovementUtil.get_surrounding_movements_for_pos(pos)
		SeachArea.KNIGHT:
			to_seach = MovementUtil.get_knight_movements_for_pos(pos)
		SeachArea.ALL:
			snakes = actor.level_manager.snakes.duplicate();
		_:
			snakes = [];
	
	if !to_seach.is_empty():
		for snake in actor.level_manager.snakes:
			match compare_with:
				CompareWith.HEAD:
					if to_seach.has(snake.head.pos):
						snakes.append(snake);
				CompareWith.TAIL:
					if to_seach.has(snake.tail.pos):
						snakes.append(snake);
	
	if must_be_alive:
		snakes = snakes.filter(func(snake : Snake): return !snake.is_dead)
	
	return snakes;
