extends BaseSpawner

class_name EnemySpawner

@onready var enemy_layer: TileMapLayer = $EnemyLayer
@onready var warning_layer: TileMapLayer = $WarningLayer

@export var level_manager : LevelManager;

## Positions where the first enemies spawn
@export var initial_enemy_pos : Array[Vector2i];

## Enemy spawn table
@export var spawn_table_resource : EnemySpawnTableResource
var total_spawn_table_weight : float;

func _ready() -> void:
	await get_tree().process_frame
	
	level_manager.spawners.append(self)
	
	if level_manager == null:
		push_error("Cannot work without a board manager reference");
	
	if spawn_table_resource == null:
		push_error("Missing spawn table");
	
	total_spawn_table_weight = spawn_table_resource.get_total_weight();
	
	for enemy_pos in initial_enemy_pos:
		spawn_enemy_at(enemy_pos, null, 0, [RANDOM_SCENE_ATTRIBUTE]);
		pass

## Spawns all spawn requests
func spawn_commit():
	for spawn_request in spawn_requests:
		if spawn_request.status != STATUS_READY:
			continue;
		
		var to_spawn_scene = spawn_request.scene
		var to_spawn_position = spawn_request.pos;
		
		if to_spawn_position == null or to_spawn_scene == null:
			spawn_request.status = STATUS_FAILED
			
			push_warning("Enemy spawn request failed")
			
			continue;
		
		var enemy : Enemy = to_spawn_scene.instantiate();
		get_tree().current_scene.add_child(enemy);
		
		var initial_global_position = enemy_layer.to_global(enemy_layer.map_to_local(to_spawn_position))
		
		enemy.initialize(to_spawn_position, initial_global_position, level_manager, enemy_layer, self);
		
		enemy.brain.save_in_brain("WarningLayer", warning_layer);
		enemy.brain.save_in_brain("WarningSource", 0);
		enemy.brain.save_in_brain("WarningAtlasCoordinate", Vector2i(0, 0));
		
		spawn_request.status = STATUS_FINISHED

## Add a spawn request to the queue
func spawn_enemy_at(pos : Vector2i, enemy_scene : PackedScene, ticks_to_spawn : int, attributes : Array[SpawnRequestAttributes]):
	var spawn_request = SpawnRequest.new(pos, enemy_scene, ticks_to_spawn, attributes);
	spawn_requests.append(spawn_request)

func get_random_enemy_scene() -> PackedScene:
	var rand_val : float = randf_range(0, total_spawn_table_weight);
	
	var weight = 0;
	var selected_entry : EnemySpawnTableEntryResource;
	for entry in spawn_table_resource.spawn_table:
		weight += entry.weight;
		if weight >= rand_val:
			selected_entry = entry;
			break;
	
	return selected_entry.scene;

func get_random_free_space():
	var spawnable_coords = level_manager.get_empty_spaces();
	
	if spawnable_coords.size() == 0:
		push_warning("No available tiles to spawn enemy");
		return null;
	
	var pos : Vector2i = spawnable_coords.pick_random();
	
	return pos;

func get_random_scene() -> PackedScene:
	return get_random_enemy_scene();

func get_random_position() -> Vector2:
	return get_random_free_space();

func solve_custom_attibutes(attibute : SpawnRequestAttributes, spawn_request : SpawnRequest):
	match attibute:
		WARNS_BEFORE_SPAWNING:
			pass;
