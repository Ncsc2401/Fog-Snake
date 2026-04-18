extends Node2D

## Position where the first fruit spawns
@export var initial_fruit_pos : Vector2i;

## Board manager reference
@export var level_manager : LevelManager;

## Tile map layer where fruits are drawn
@export var fruit_layer : TileMapLayer

func _ready() -> void:
	await get_tree().process_frame
	
	if level_manager == null:
		push_error("Cannot work without a board manager reference");
	
	if fruit_layer == null:
		push_error("Cannot work without a fruit layer reference");
	
	spawn_fruit_at(initial_fruit_pos);
	
	GlobalSignals.FruitWasEaten.connect(on_fruit_was_eaten)

func on_fruit_was_eaten(where : Vector2i):
	fruit_layer.erase_cell(where);
	spawn_fruit_random();

## Places a fruit at the given position, do not check if position is valid
func spawn_fruit_at(pos : Vector2i):
	level_manager.set_cell(pos, BoardData.FRUIT)
	fruit_layer.set_cell(pos, 0, Vector2i(0, 0))

## Spawns a fruit randomly or not if there isn't any available tiles
func spawn_fruit_random():
	var spawnable_coords = level_manager.get_empty_cells();
	
	if spawnable_coords.size() == 0:
		push_warning("No available tiles to spawn fruit");
		return;
	
	var tile : Vector2i = spawnable_coords.pick_random();
	
	spawn_fruit_at(tile)
