extends BaseFruit

func on_fruit_tick():
	pass

func on_eat():
	fruit_spawner.spawn_fruit_at(Vector2i.ZERO, null, 0, [BaseSpawner.RANDOM_POSITION_ATTRIBUTE, BaseSpawner.RANDOM_SCENE_ATTRIBUTE])
	delete_self()
