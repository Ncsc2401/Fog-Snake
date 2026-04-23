extends BaseFruit

func on_fruit_tick():
	pass

func on_eat():
	fruit_spawner.spawn_random_fruit_random();
	delete_self()
