@tool
extends Node

const FOLDER_PATH = "res://BoardData/"

@export_tool_button("Save", "Callable") var save = generate_board_data
@export_tool_button("Generate walls", "Callable") var walls_gen = generate_walls
@export_tool_button("Generate background", "Callable") var background_gen = generate_background
@export_tool_button("Clear", "Callable") var clear_all = clear;

@export var board_data_name : String
@export var board_area_layer : TileMapLayer;
@export var wall_layer : TileMapLayer
@export var background_layer : TileMapLayer

func generate_board_data():
	if board_area_layer == null:
		printerr("No board area layer reference");
		return
		
	if wall_layer == null:
		printerr("No wall layer reference");
		return
	
	if board_data_name.is_empty():
		printerr("Insert valid name for file.")
		return;
	
	var data : BoardData = BoardData.new();
	
	for cell in board_area_layer.get_used_cells():
		data.board[cell] = BoardData.EMPTY;
	
	for cell in wall_layer.get_used_cells():
		data.board[cell] = BoardData.WALL;
	
	var path = FOLDER_PATH + board_data_name + ".tres";
	
	var error = ResourceSaver.save(data, path);
	
	if(error == OK):
		print("Resource saved successfully at ", path);
		EditorInterface.get_resource_filesystem().scan();
	else:
		printerr("Failed to save resource. ", error);

# Creates a out border of walls
func generate_walls():
	if wall_layer == null:
		printerr("No wall layer reference");
		return
	
	if board_area_layer == null:
		printerr("No board area layer reference");
		return
		
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
	
	print("Walls generated")

# Creates a checkers pattern
func generate_background():
	if background_layer == null:
		printerr("No background layer reference");
		return
		
	for tile_coord in board_area_layer.get_used_cells():
		var tile : Vector2i;
		
		if((tile_coord.x + tile_coord.y) % 2 == 0):
			tile = Vector2i(0, 0);
		else:
			tile = Vector2i(1, 0)
			
		background_layer.set_cell(tile_coord, 0, tile);
	
	print("Background generated")

func clear():
	for cell in wall_layer.get_used_cells():
		wall_layer.erase_cell(cell);
	
	for cell in background_layer.get_used_cells():
		background_layer.erase_cell(cell);
	
	print("All cleared")
