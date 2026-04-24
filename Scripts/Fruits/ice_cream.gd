extends BaseFruit

func on_eat():
	fruit_spawner.spawn_random_fruit_random()
	delete_self()

func on_fruit_tick():
	var empty_spaces = level_manager.get_empty_spaces();
	
	if empty_spaces.size() > 0:
		move_to(empty_spaces.pick_random());
