extends BaseSpawner

class_name FruitSpawner

## Positions where the first fruits spawn it is always random
@export var initial_fruit_pos : Array[Vector2i];

## Board manager reference
@export var level_manager : LevelManager;

## Fruit spawn table
@export var spawn_table_resource : FruitSpawnTableResource

## Tile map layer for reference to where to spawn
@onready var fruit_layer: TileMapLayer = $FruitLayer

func _ready() -> void:
	await get_tree().process_frame
	
	level_manager.spawners.append(self)
	
	if level_manager == null:
		push_error("Cannot work without a board manager reference");
	
	if spawn_table_resource == null:
		push_error("Missing spawn table");
	
	for fruit_pos in initial_fruit_pos:
		spawn_fruit_at(fruit_pos, null, 0, [RANDOM_SCENE_ATTRIBUTE]);
		pass

## Spawns all spawn requests
func spawn_commit():
	for spawn_request in spawn_requests:
		if spawn_request.status != STATUS_READY:
			continue
			
		var to_spawn_scene = spawn_request.scene 
		
		## Is a vector2i most of the time
		var to_spawn_position = spawn_request.pos;
		
		if to_spawn_position == null or to_spawn_scene == null:
			spawn_request.status = STATUS_FAILED
			push_warning("Fruit spawn request failed")
			continue;
		
		var fruit : Fruit = to_spawn_scene.instantiate();
		get_tree().current_scene.add_child(fruit);
		
		var initial_global_position = fruit_layer.to_global(fruit_layer.map_to_local(to_spawn_position))
		fruit.initialize(to_spawn_position, initial_global_position, level_manager, fruit_layer, self);
		
		spawn_request.status = STATUS_FINISHED

## Add a spawn request to the queue
func spawn_fruit_at(pos : Vector2i, fruit_scene : PackedScene, ticks_to_spawn : int, attributes : Array):
	var spawn_request = SpawnRequest.new(pos, fruit_scene, ticks_to_spawn, attributes);
	spawn_requests.append(spawn_request)

func get_random_fruit_scene() -> PackedScene:
	var total_spawn_table_weight = spawn_table_resource.get_total_weight();
	
	var rand_val : float = randf_range(0, total_spawn_table_weight);
	
	var weight = 0;
	var selected_entry : FruitSpawnTableEntryResource;
	for entry in spawn_table_resource.spawn_table:
		weight += entry.weight;
		if weight >= rand_val:
			selected_entry = entry;
			break;
	
	return selected_entry.scene;

func get_random_free_space():
	var spawnable_coords = level_manager.get_empty_spaces();
	
	if spawnable_coords.size() == 0:
		push_warning("No available tiles to spawn fruit");
		return null;
	
	var pos : Vector2i = spawnable_coords.pick_random();
	
	return pos;

func get_random_scene() -> PackedScene:
	return get_random_fruit_scene();

func get_random_position():
	return get_random_free_space();

func solve_custom_attibutes(attibute : SpawnRequestAttributes, spawn_request : SpawnRequest):
	pass

func spawn_at(pos : Vector2i, enemy_scene : PackedScene, ticks_to_spawn : int, attributes : Array):
	spawn_fruit_at(pos, enemy_scene, ticks_to_spawn, attributes)
