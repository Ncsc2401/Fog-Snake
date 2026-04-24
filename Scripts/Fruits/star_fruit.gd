extends BaseFruit

func on_fruit_tick():
	var around_pos = [
		pos + Vector2i(0, 1),
		pos + Vector2i(0, -1),
		pos + Vector2i(1, 0),
		pos + Vector2i(-1, 0),
	]
	
	var new_pos = around_pos.pick_random();
	
	if level_manager.is_space_empty(new_pos):
		move_to(new_pos);

func on_eat():
	fruit_spawner.spawn_random_fruit_random();
	delete_self();
