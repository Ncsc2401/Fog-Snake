extends Actor

class_name Enemy

@export var enemy_resource : EnemyResource

@export var death_component : BaseEnemyDeathComponent;

var l_death_component : BaseEnemyDeathComponent

func initialize(initial_board_position : Vector2i, initial_global_position : Vector2, level_manager : LevelManager, reference_tilemap : TileMapLayer, actor_spawner : BaseSpawner):
	super(initial_board_position, initial_global_position, level_manager, reference_tilemap, actor_spawner)
	level_manager.enemies.append(self);
	
	l_death_component = death_component.duplicate();

func die():
	death_component.on_death();
	delete_self()

func delete_self():
	level_manager.enemies.erase(self);
	queue_free()
