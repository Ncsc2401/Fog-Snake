extends BaseEnemy

var next_pos : Vector2i;

func on_spawn():
	next_pos = level_manager.get_empty_spaces().pick_random();

func on_die():
	pass

func on_enemy_tick():
	if level_manager.is_space_empty(next_pos):
		move_to(next_pos)
	clear_warnings();
	
	next_pos = level_manager.get_empty_spaces().pick_random();

func on_enemy_warning_window():
	warn_player(next_pos);

func is_enemy_alive():
	return true;
