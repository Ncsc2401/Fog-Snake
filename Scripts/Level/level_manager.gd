extends Node2D

class_name LevelManager

@export var points_to_win : int;

var points = 0;
var stating_tick;

@export var initial_board : BoardData

@export var snake : Snake
@export var game_over_menu : Control;
@export var score_ui : Control

var board : Dictionary[Vector2i, BoardData.CellType];
var fruits : Dictionary[Vector2i, BaseFruit];

func _ready() -> void:
	points = 0;
	stating_tick = GlobalSignals.ticks;
	board = initial_board.board.duplicate();
	snake.GameOver.connect(on_game_over);

func eat_fruit(pos : Vector2i) -> FruitResource:
	if !fruits.has(pos):
		push_warning("Cannot eat fruit, because it doesn't exist");
		return FruitResource.new();
	
	var fruit = fruits[pos];
	
	fruits.erase(pos);
	
	fruit.on_eat_call();
	
	points += fruit.fruit_resource.points;
	score_ui.update_display(points);
	
	return fruit.fruit_resource;

func on_game_over():
	# Display game over menu
	game_over_menu.activate();
	
	# Save new data
	var new_data = MapLevelSaveableData.new();
		
	new_data.unlocked = true # Kinda redundant
	new_data.max_points = points;
	new_data.max_size = snake.body_size
	new_data.least_time = -1;
	
	# Unlock levels
	if points >= points_to_win:
		SaveManager.unlock_current_surrounding_levels();
		new_data.least_time = (GlobalSignals.ticks - stating_tick)*GlobalSignals.tick_time
	
	SaveManager.update_current_map_level_save(new_data);

## Returns the cell type from a position in the board. Returns BoardData.CellType.OUT_OF_BOUNDS if entry doesn't exist
func get_cell(pos : Vector2i) -> BoardData.CellType:
	if board.has(pos):
		return board[pos];
	
	return BoardData.CellType.OUT_OF_BOUNDS

## Set a cell at the given position on the board to the given type. Makes a warning when setting a non existing entry and creates a new entry
func set_cell(pos : Vector2i, cell_type : BoardData.CellType):
	if !board.has(pos): push_warning("Creating new cell at runtime");
	board[pos] = cell_type;

func get_empty_cells() -> Array[Vector2i]:
	var empty_cells : Array[Vector2i] = [];
	
	for board_pos in board.keys():
		if board[board_pos] == BoardData.EMPTY:
			empty_cells.append(board_pos);
	
	return empty_cells;
