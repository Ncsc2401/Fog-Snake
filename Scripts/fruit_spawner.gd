extends Node2D

## Position where the first fruit spawns
@export var initial_fruit_pos : Vector2i;

## Tile map layer where the snake is drawn
@export var snake_layer : TileMapLayer
## Tile map layer that defines the board area
@export var board_area_layer : TileMapLayer
## Tile map layer where fruits are drawn
@export var fruit_layer : TileMapLayer

## List of all spawnable tiles
var spawnable_coords : Array[Vector2i]

func _ready() -> void:
	spawnable_coords = board_area_layer.get_used_cells();
	
	spawn_fruit_at(initial_fruit_pos);
	
	GlobalSignals.FruitWasEaten.connect(spawn_fruit_random)

## Places a fruit at the given position, do not check if position is valid
func spawn_fruit_at(pos : Vector2i):
	fruit_layer.set_cell(pos, 0, Vector2i(0, 0))

## Spawns a fruit randomly or not if there isn't any available tiles
func spawn_fruit_random():
	# Copy spawnable coords so the original isn't affected
	var spawnable_coords_copy = spawnable_coords.duplicate();
	
	# While there is available tiles, pick one at random and check if it is valid
	# If not, removes from the list and tries again
	# If so, calls spawn_fruit_at on that tile
	while(spawnable_coords.size() > 0):
		var tile : Vector2i = spawnable_coords_copy.pick_random();
		
		if(snake_layer.get_cell_source_id(tile) != -1):
			spawnable_coords_copy.erase(tile);
			continue;
		
		spawn_fruit_at(tile)
		break;
