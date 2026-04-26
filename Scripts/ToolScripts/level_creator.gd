@tool
extends Node

const FOLDER_PATH = "res://BoardData/"

@export_subgroup("Buttons")
@export_tool_button("Generate all", "Button") var gen_all = generate_all
@export_tool_button("Save", "Save") var save = generate_board_data
@export_tool_button("Generate walls", "Grid") var walls_gen = generate_walls
@export_tool_button("Generate background", "Grid") var background_gen = generate_background
@export_tool_button("Reverse generate", "PreviewRotate") var rev_gen = reverse_generate
@export_tool_button("Clear", "Clear") var clear_all = clear;
@export_tool_button("Full clear", "Clear") var full_cle = full_clear

@export_subgroup("Input options")
@export var board_data_name : String
@export var overwrite_if_exist : bool;
@export var board_area_layer : TileMapLayer;
@export var enemy_layer : TileMapLayer
@export var fruit_layer : TileMapLayer
@export var board_data : BoardData

@export_subgroup("Output options")
@export var level_root : Node2D
@export var wall_layer : TileMapLayer
@export var background_layer : TileMapLayer
@export var enemy_spawner : EnemySpawner
@export var fruit_spawner : FruitSpawner
@export var level_manager : LevelManager

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
	
	var path = FOLDER_PATH + board_data_name.capitalize().replace(" ", "") + ".tres";
	
	if FileAccess.file_exists(path) && !overwrite_if_exist:
		print("File already exists and cannot overwrite");
		return;
	
	var error = ResourceSaver.save(data, path);
	
	if(error == OK):
		print("Resource saved successfully at ", path);
		EditorInterface.get_resource_filesystem().scan();
	else:
		printerr("Failed to save resource. ", error);

func reverse_generate():
	clear();
	board_area_layer.clear()
	
	for cell in board_data.board.keys():
		if board_data.board[cell] == BoardData.EMPTY:
			board_area_layer.set_cell(cell, 0, Vector2i(0, 0));
		elif board_data.board[cell] == BoardData.WALL:
			wall_layer.set_cell(cell, 0, Vector2i(0, 0));
	
	print("Reverse generated")

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

func generate_all():
	generate_walls()
	generate_background()
	
	setup_fruit_spawner()
	setup_enemy_spawner()
	setup_level_root()
	
	generate_board_data();
	setup_level_manager();

func setup_fruit_spawner():
	fruit_spawner.initial_fruit_pos = fruit_layer.get_used_cells();
	print("Fruit spawner setup")

func setup_enemy_spawner():
	enemy_spawner.initial_enemy_pos = enemy_layer.get_used_cells();
	print("Enemy setup")

func setup_level_manager():
	var data : BoardData = load(FOLDER_PATH + board_data_name.capitalize().replace(" ", "") + ".tres")
	
	level_manager.board_data = data;
	print("Level manager setup")

func setup_level_root():
	level_root.name = board_data_name.capitalize().replace(" ", "")
	print("Level root setup")

func clear():
	wall_layer.clear()
	background_layer.clear()
	
	level_root.name = "Level"
	
	print("All cleared")

func full_clear():
	wall_layer.clear()
	background_layer.clear()
	
	level_root.name = "Level"
	
	enemy_layer.clear()
	fruit_layer.clear()
	board_area_layer.clear()
