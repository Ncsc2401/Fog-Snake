extends Actor

class_name Enemy

@export var enemy_resource : EnemyResource
var l_enemy_resource : EnemyResource

@export var death_components : Array[BaseEnemyDeathComponent];
var l_death_components : Array[BaseEnemyDeathComponent]

func initialize(initial_board_position : Vector2i, initial_global_position : Vector2, level_manager : LevelManager, reference_tilemap : TileMapLayer, actor_spawner : BaseSpawner):
	super(initial_board_position, initial_global_position, level_manager, reference_tilemap, actor_spawner)
	level_manager.enemies.append(self);
	
	l_enemy_resource = enemy_resource.duplicate()
	
	for death_component in death_components:
		var l_death_component = death_component.duplicate()
		l_death_components.append(l_death_component)
		l_death_component.initialize(self);

func die():
	for l_death_component in l_death_components:
		await l_death_component.on_death();
	delete_self()

func delete_self():
	level_manager.enemies.erase(self);
	queue_free()
