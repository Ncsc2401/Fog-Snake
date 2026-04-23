extends Node2D

class_name FruitSpawner

##Positions where the first fruits spawn
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

## Places a fruit at the given position, do not check if position is valid
func spawn_fruit_at(pos : Vector2i, fruit_scene : PackedScene):
	var fruit : BaseFruit = fruit_scene.instantiate();
	get_tree().current_scene.add_child(fruit);
	level_manager.fruits[pos] = fruit;
	fruit.level_manager = level_manager;
	fruit.fruit_layer = fruit_layer;
	fruit.fruit_spawner = self;
	fruit.move_to(pos);

## Spawns a random fruit at the given position, do not check if position is valid
func spawn_random_fruit_at(pos : Vector2i):
	var fruit_scene = get_random_fruit_scene();
	
	spawn_fruit_at(pos, fruit_scene);

## Spawns a random fruit randomly or not if there isn't any available tiles
func spawn_random_fruit_random():
	var spawnable_coords = level_manager.get_empty_cells();
	
	if spawnable_coords.size() == 0:
		push_warning("No available tiles to spawn fruit");
		return;
	
	var pos : Vector2i = spawnable_coords.pick_random();
	
	spawn_random_fruit_at(pos);

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
