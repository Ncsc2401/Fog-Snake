extends BaseFruitEatComponent

class_name SpawnFruitEatComponent

@export var fruit_scene : PackedScene

func on_eat():
	fruit.fruit_spawner.spawn_fruit_at(Vector2.ZERO, fruit_scene, 0, [BaseSpawner.RANDOM_POSITION_ATTRIBUTE])
