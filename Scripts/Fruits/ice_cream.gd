extends BaseFruit

func on_eat():
	fruit_spawner.spawn_fruit_at(Vector2i.ZERO, null, 0, [BaseSpawner.RANDOM_POSITION_ATTRIBUTE, BaseSpawner.RANDOM_SCENE_ATTRIBUTE])
	delete_self()

func on_fruit_tick():
	var empty_spaces = level_manager.get_empty_spaces();
	
	if empty_spaces.size() > 0:
		move_to(empty_spaces.pick_random());
