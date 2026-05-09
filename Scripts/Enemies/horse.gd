extends BaseEnemy

var horse_movements = [
	Vector2i(1, -2),
	Vector2i(2, -1),
	Vector2i(2, 1),
	Vector2i(1, 2),
	Vector2i(-1, 2),
	Vector2i(-2, 1),
	Vector2i(-2, -1),
	Vector2i(-1, -2),
]

var next_movement : Vector2i;

func on_enemy_warning_window():
	warn_player(next_movement)

func on_enemy_tick():
	if level_manager.is_space_empty(next_movement):
		move_to(next_movement);
	
	clear_warnings()
	
	var available_movements = horse_movements.duplicate()
	available_movements.shuffle();
	
	for move in available_movements:
		var final_pos = board_pos + move;
		
		if level_manager.is_space_empty(final_pos):
			next_movement = final_pos;
			return;

func on_die():
	clear_warnings()
	queue_free()
	level_manager.enemies.erase(self);

func on_spawn():
	var available_movements = horse_movements.duplicate()
	available_movements.shuffle();
	
	for move in available_movements:
		var final_pos = board_pos + move;
		
		if level_manager.is_space_empty(final_pos):
			next_movement = final_pos;
			return;

func is_enemy_alive():
	for horse_movement in horse_movements:
		if level_manager.is_space_empty(board_pos + horse_movement):
			return true;
		
	return false;
