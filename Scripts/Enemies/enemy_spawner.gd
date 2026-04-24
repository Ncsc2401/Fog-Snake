extends BaseSpawner

class_name EnemySpawner

@onready var enemy_layer: TileMapLayer = $EnemyLayer

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
		spawn_random_enemy_at(enemy_pos);
		pass

## Spawns all spawn requests
func spawn_commit():
	for spawn_request in spawn_requests:
		var to_spawn_scene : PackedScene
		var to_spawn_position; ## Is a vector2i most of the time, but can be null
		
		if spawn_request.is_random_scene:
			to_spawn_scene = get_random_enemy_scene();
		else:
			to_spawn_scene = spawn_request.scene;
		
		if spawn_request.is_random_pos:
			to_spawn_position = get_random_free_space();
		else:
			to_spawn_position = spawn_request.pos
		
		if to_spawn_position == null:
			continue;
		
		var enemy : BaseEnemy = to_spawn_scene.instantiate();
		get_tree().current_scene.add_child(enemy);
	
		enemy.level_manager = level_manager;
		enemy.enemy_layer = enemy_layer;
		enemy.enemy_spawner = self;
		
		enemy.move_to(to_spawn_position);
		
		enemy.on_spawn()

func clear_requests():
	spawn_requests.clear();

## Add a spawn request to the queue
func spawn_enemy_at(pos : Vector2i, enemy_scene : PackedScene):
	var spawn_request = SpawnRequest.new(pos, enemy_scene, false, false);
	spawn_requests.append(spawn_request)

## Spawns a random enemy at the given position, do not check if position is valid
func spawn_random_enemy_at(pos : Vector2i):
	var spawn_request = SpawnRequest.new(pos, null, false, true);
	spawn_requests.append(spawn_request)

## Spawns a random enemy randomly or not if there isn't any available tiles
func spawn_random_enemy_random():
	var spawn_request = SpawnRequest.new(Vector2i.ZERO, null, true, true);
	spawn_requests.append(spawn_request)

## Spawns a enemy randomly or not if there isn't any available tiles
func spawn_enemy_random(enemy_scene : PackedScene):
	var spawn_request = SpawnRequest.new(Vector2i.ZERO, enemy_scene, true, false);
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
