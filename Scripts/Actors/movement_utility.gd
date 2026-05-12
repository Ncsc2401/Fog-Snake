extends RefCounted

class_name MovementUtil

const CARDINAL_RELATIVE_MOVES : Array[Vector2i] = [
	Vector2i(1, 0),
	Vector2i(0, 1),
	Vector2i(-1, 0),
	Vector2i(0, -1),
]

const KNIGHT_RELATIVE_MOVES : Array[Vector2i] = [
	Vector2i(1, -2),
	Vector2i(2, -1),
	Vector2i(2, 1),
	Vector2i(1, 2),
	Vector2i(-1, 2),
	Vector2i(-2, 1),
	Vector2i(-2, -1),
	Vector2i(-1, -2),
]

const SURROUNDING_RELATIVE_MOVES : Array[Vector2i] = [
	Vector2i(1, 0),
	Vector2i(1, 1),
	Vector2i(0, 1),
	Vector2i(-1, 1),
	Vector2i(-1, 0),
	Vector2i(-1, -1),
	Vector2i(0, -1),
	Vector2i(1, -1),
]

static func get_knight_movements_for_pos(pos : Vector2i) -> Array[Vector2i]:
	return get_movement_for_pos_from_relatives_moves(pos, KNIGHT_RELATIVE_MOVES);

static func get_surrounding_movements_for_pos(pos : Vector2i) -> Array[Vector2i]:
	return get_movement_for_pos_from_relatives_moves(pos, SURROUNDING_RELATIVE_MOVES);

static func get_cardinal_movements_for_pos(pos : Vector2i) -> Array[Vector2i]:
	return get_movement_for_pos_from_relatives_moves(pos, CARDINAL_RELATIVE_MOVES);

static func get_movement_for_pos_from_relatives_moves(pos : Vector2i, relative_moves : Array[Vector2i]) -> Array[Vector2i]:
	var possible_movements : Array[Vector2i] = []
	
	for relative_move in relative_moves:
		var final_pos = pos + relative_move;
		possible_movements.append(final_pos);
	
	return possible_movements;

static func get_closest_towards_movement_to_vector(vector : Vector2, movements : Array[Vector2i]):
	if movements.is_empty():
		return Vector2i.ZERO
	
	var movements_copy = movements.duplicate();
	
	## This is to ensure a randomness in case 2 vector are equally similar
	movements_copy.shuffle();
	
	var similarity_map : Dictionary[float, Vector2i] = {};
	
	var vec_mag = vector.length();
	
	for movement in movements_copy:
		var similarity = abs(Vector2(movement).dot(vector) - vec_mag);
		similarity_map[similarity] = movement;
	
	return similarity_map[similarity_map.keys().min()];

static func get_closest_away_movement_to_vector(vector : Vector2, movements : Array[Vector2i]):
	if movements.is_empty():
		return Vector2i.ZERO
	
	var movements_copy = movements.duplicate();
	
	## This is to ensure a randomness in case 2 vector are equally similar
	movements_copy.shuffle();
	
	var un_similarity_map : Dictionary[float, Vector2i] = {};
	
	var vec_mag = vector.length();
	
	for movement in movements_copy:
		var similarity = abs(Vector2(movement).dot(-vector) - vec_mag);
		un_similarity_map[similarity] = movement;
	
	return un_similarity_map[un_similarity_map.keys().max()];
