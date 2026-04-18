extends Node2D

class_name LevelManager

## NOT YET IMPLEMENTED
@export var points_to_win : int;

## NOT YET IMPLEMENTED
@export var next_lavel_name : String

@export var initial_board : BoardData

var board : Dictionary[Vector2i, BoardData.CellType];

func _ready() -> void:
	board = initial_board.board.duplicate();

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
