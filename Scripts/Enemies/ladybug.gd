extends BaseEnemy

var next_pos : Vector2i;
var got_valid_pos : bool = false;;

func on_spawn():
	var around_pos = [
		board_pos + Vector2i(0, 1),
		board_pos + Vector2i(0, -1),
		board_pos + Vector2i(1, 0),
		board_pos + Vector2i(-1, 0),
	]
	
	around_pos.shuffle()
	for pos in around_pos:
		next_pos = pos
		if level_manager.is_space_wall(next_pos) ||\
		!level_manager.is_space_in_bounds(next_pos) ||\
		level_manager.has_space_enemy(next_pos):
			got_valid_pos = false;
			continue;
		got_valid_pos = true;
		break;

func on_die():
	pass

func on_enemy_tick():
	if got_valid_pos && level_manager.is_space_empty(next_pos):
		move_to(next_pos)
	clear_warnings();
	
	var around_pos = [
		board_pos + Vector2i(0, 1),
		board_pos + Vector2i(0, -1),
		board_pos + Vector2i(1, 0),
		board_pos + Vector2i(-1, 0),
	]
	
	around_pos.shuffle()
	for pos in around_pos:
		next_pos = pos
		if level_manager.is_space_wall(next_pos) ||\
		!level_manager.is_space_in_bounds(next_pos) ||\
		level_manager.has_space_enemy(next_pos):
			got_valid_pos = false;
			continue;
		got_valid_pos = true;
		break;

func on_enemy_warning_window():
	if !got_valid_pos:
		return;
	
	warn_player(next_pos);

func is_enemy_alive():
	return true;
