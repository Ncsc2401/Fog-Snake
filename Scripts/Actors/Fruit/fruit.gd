extends Actor

class_name Fruit

@export var fruit_resource : FruitResource
var l_fruit_resource : FruitResource

@export var fruit_eat_components : Array[BaseFruitEatComponent]
var l_fruit_eat_components : Array[BaseFruitEatComponent];

var fruit_spawner : FruitSpawner

var was_eaten : bool = false;

func initialize(initial_board_position : Vector2i, initial_global_position : Vector2, level_manager : LevelManager, reference_tilemap : TileMapLayer, actor_spawner : BaseSpawner):
	super(initial_board_position, initial_global_position, level_manager, reference_tilemap, actor_spawner)
	fruit_spawner = actor_spawner as FruitSpawner;
	level_manager.fruits.append(self);
	
	l_fruit_resource = fruit_resource.duplicate()
	
	for fruit_eat_component in fruit_eat_components:
		l_fruit_eat_components.append(fruit_eat_component.duplicate());
	
	for l_fruit_eat_component in l_fruit_eat_components:
		l_fruit_eat_component.initialize(self);

func on_eat():
	was_eaten = true;
	for l_fruit_eat_component in l_fruit_eat_components:
		if l_fruit_eat_component.is_initialized:
			await l_fruit_eat_component.on_eat();
	delete_self()

func delete_self():
	level_manager.fruits.erase(self)
	queue_free()
