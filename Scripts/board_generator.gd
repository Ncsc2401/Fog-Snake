extends Node2D

# TODO maybe fix this so boards can be generated procedurally?

@export var board_area_layer : TileMapLayer
@export var background_layer : TileMapLayer
@export var wall_layer : TileMapLayer

func _ready() -> void:
	generate_walls()
	generate_background()

# Creates a out border of walls
# Really inneficient, costly and unflexible
func generate_walls():
	var directions = [
		Vector2i(0, 1),
		Vector2i(0, -1),
		Vector2i(1, 0),
		Vector2i(-1, 0),
		Vector2i(-1, -1),
		Vector2i(-1, 1),
		Vector2i(1, -1),
		Vector2i(1, 1),
	]
	
	var out_border : Array[Vector2i];
	
	for tile_coord in board_area_layer.get_used_cells():
		for direction in directions:
			var out_border_coord = tile_coord + direction;
			if board_area_layer.get_cell_source_id(out_border_coord) == -1:
				out_border.append(out_border_coord);
	
	for out_border_coord in out_border:
		wall_layer.set_cell(out_border_coord, 0, Vector2i(0, 0));

# Creates a checkers pattern
func generate_background():
	for tile_coord in board_area_layer.get_used_cells():
		var tile : Vector2i;
		
		if((tile_coord.x + tile_coord.y) % 2 == 0):
			tile = Vector2i(0, 0);
		else:
			tile = Vector2i(1, 0)
		
		
		background_layer.set_cell(tile_coord, 1, tile);
