extends BaseSpawner

class_name FruitSpawner

## Positions where the first fruits spawn it is always random
@export var initial_fruit_pos : Array[Vector2i];

## Board manager reference
@export var level_manager : LevelManager;

## Fruit spawn table
@export var spawn_table_resource : FruitSpawnTableResource
var total_spawn_table_weight : float;

## Tile map layer where fruits are drawn
@onready var fruit_layer: TileMapLayer = $FruitLayer

func _ready() -> void:
	await get_tree().process_frame
	
	level_manager.spawners.append(self)
	
	if level_manager == null:
		push_error("Cannot work without a board manager reference");
	
	if spawn_table_resource == null:
		push_error("Missing spawn table");
	
	total_spawn_table_weight = spawn_table_resource.get_total_weight();
	
	for fruit_pos in initial_fruit_pos:
		spawn_random_fruit_at(fruit_pos);
		pass

func on_fruit_was_eaten(where : Vector2i):
	fruit_layer.erase_cell(where);
	spawn_random_fruit_random();

## Spawns all spawn requests
func spawn_commit():
	for spawn_request in spawn_requests:
		var to_spawn_scene : PackedScene
		var to_spawn_position; ## Is a vector2i most of the time, but can be null
		
		if spawn_request.is_random_scene:
			to_spawn_scene = get_random_fruit_scene();
		else:
			to_spawn_scene = spawn_request.scene;
		
		if spawn_request.is_random_pos:
			to_spawn_position = get_random_free_space();
		else:
			to_spawn_position = spawn_request.pos
		
		if to_spawn_position == null:
			continue;
		
		var fruit : BaseFruit = to_spawn_scene.instantiate();
		get_tree().current_scene.add_child(fruit);
	
		fruit.level_manager = level_manager;
		fruit.fruit_layer = fruit_layer;
		fruit.fruit_spawner = self;
		
		fruit.move_to(to_spawn_position);

func clear_requests():
	spawn_requests.clear();

## Add a spawn request to the queue
func spawn_fruit_at(pos : Vector2i, fruit_scene : PackedScene):
	var spawn_request = SpawnRequest.new(pos, fruit_scene, false, false);
	spawn_requests.append(spawn_request)

## Spawns a random fruit at the given position, do not check if position is valid
func spawn_random_fruit_at(pos : Vector2i):
	var spawn_request = SpawnRequest.new(pos, null, false, true);
	spawn_requests.append(spawn_request)

## Spawns a random fruit randomly or not if there isn't any available tiles
func spawn_random_fruit_random():
	var spawn_request = SpawnRequest.new(Vector2i.ZERO, null, true, true);
	spawn_requests.append(spawn_request)

## Spawns a fruit randomly or not if there isn't any available tiles
func spawn_fruit_random(fruit_scene : PackedScene):
	var spawn_request = SpawnRequest.new(Vector2i.ZERO, fruit_scene, true, false);
	spawn_requests.append(spawn_request)

func get_random_fruit_scene() -> PackedScene:
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
