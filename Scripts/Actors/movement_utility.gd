extends RefCounted

class_name MovementUtil

const CARDINAL_RELATIVE_MOVES = [
	Vector2i(1, 0),
	Vector2i(0, 1),
	Vector2i(-1, 0),
	Vector2i(0, -1),
]

const KNIGHT_RELATIVE_MOVES = [
	Vector2i(1, -2),
	Vector2i(2, -1),
	Vector2i(2, 1),
	Vector2i(1, 2),
	Vector2i(-1, 2),
	Vector2i(-2, 1),
	Vector2i(-2, -1),
	Vector2i(-1, -2),
]

const SURROUNDING_RELATIVE_MOVES = [
	Vector2i(1, 0),
	Vector2i(1, 1),
	Vector2i(0, 1),
	Vector2i(-1, 1),
	Vector2i(-1, 0),
	Vector2i(-1, -1),
	Vector2i(0, -1),
	Vector2i(1, -1),
]

static func get_knight_movements_for_actor(actor : Actor):
	var possible_movements = []
	
	for relative_move in KNIGHT_RELATIVE_MOVES:
		var final_pos = actor.board_position + relative_move;
		
		if actor.level_manager.is_space_empty(final_pos):
			possible_movements.append(final_pos);
	
	return possible_movements;

static func get_surrounding_movements_for_actor(actor : Actor):
	var possible_movements = []
	
	for relative_move in SURROUNDING_RELATIVE_MOVES:
		var final_pos = actor.board_position + relative_move;
		
		if actor.level_manager.is_space_empty(final_pos):
			possible_movements.append(final_pos);
	
	return possible_movements

static func get_cardinal_movements_for_actor(actor : Actor):
	var possible_movements = []
	
	for relative_move in CARDINAL_RELATIVE_MOVES:
		var final_pos = actor.board_position + relative_move;
		
		if actor.level_manager.is_space_empty(final_pos):
			possible_movements.append(final_pos);
	
	return possible_movements;
