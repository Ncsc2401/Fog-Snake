extends BaseFruit

func on_eat():
	fruit_spawner.spawn_random_fruit_random()
	delete_self()

func on_fruit_tick():
	var empty_cells = level_manager.get_empty_cells();
	
	if empty_cells.size() > 0:
		move_to(empty_cells.pick_random());
