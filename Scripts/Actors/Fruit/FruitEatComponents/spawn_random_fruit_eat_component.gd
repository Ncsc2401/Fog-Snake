extends BaseFruitEatComponent

class_name SpawnRandomFruitEatComponent

func on_eat():
	fruit.fruit_spawner.spawn_fruit_at(Vector2.ZERO, null, 0, [BaseSpawner.RANDOM_POSITION_ATTRIBUTE, BaseSpawner.RANDOM_SCENE_ATTRIBUTE])
