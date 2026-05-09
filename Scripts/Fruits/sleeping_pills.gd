extends BaseFruit

func on_fruit_tick():
	pass

func on_eat():
	var game_speed = GlobalSignals.tick_time;
	
	level_manager.change_game_speed(game_speed * 1.1);
	
	fruit_spawner.spawn_fruit_at(Vector2i.ZERO, null, 0, [BaseSpawner.RANDOM_POSITION_ATTRIBUTE, BaseSpawner.RANDOM_SCENE_ATTRIBUTE])
	delete_self()
