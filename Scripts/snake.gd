extends Node2D

class_name Snake

signal GameOver()

## Directions the snake can move
enum Directions {
	LEFT = 0,
	RIGHT = 1,
	UP = 2,
	DOWN = 3,
}

## Converts enum direction to a vector
var direction_to_vector : Dictionary = {
	Directions.LEFT : Vector2i(-1, 0),
	Directions.RIGHT : Vector2i(1, 0),
	Directions.UP : Vector2i(0, -1),
	Directions.DOWN : Vector2i(0, 1),
}

## Initial snake body, index 0 is the head
@export var initial_body : Array[Vector2i];
## Initial direction the player starts
@export var initial_direction : Directions;

## Tile map layer where the snake is drawn
@export var snake_layer : TileMapLayer;

## Board manager reference
@export var level_manager : LevelManager;

## All tiles occupied by the snake
var body : Array[Vector2i];
## The direction the snake is currently moving towards
var direction : Directions;
## Last direction the snake moved
var last_direction : Directions;

## Size of the snake
var points : int = 0;

func _ready() -> void:
	await get_tree().process_frame
	
	if level_manager == null:
		push_error("Cannot work without a board manager reference");
	
	if snake_layer == null:
		push_error("Cannot work without a snake layer reference")
		
	if initial_direction == null:
		push_warning("No initial diretion setted")
		
	if initial_body == null:
		push_warning("No initial body setted")
	
	for body_part in initial_body:
		if level_manager.get_cell(body_part) != BoardData.EMPTY:
			push_warning("Snake spawning inside occupied cell");
	
	body = initial_body.duplicate();
	direction = initial_direction;
	
	GlobalSignals.Tick.connect(move);
	
	# First snake drawn
	for body_part in initial_body:
		snake_layer.set_cell(body_part, 0, Vector2i(1, 0));
		level_manager.set_cell(body_part, BoardData.SNAKE)
	snake_layer.set_cell(body[0], 0, Vector2i(0, 0))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Down") && last_direction != Directions.UP:
		direction = Directions.DOWN;
	if event.is_action_pressed("Up") && last_direction != Directions.DOWN:
		direction = Directions.UP;
	if event.is_action_pressed("Left") && last_direction != Directions.RIGHT:
		direction = Directions.LEFT;
	if Input.is_action_just_pressed("Right") && last_direction != Directions.LEFT:
		direction = Directions.RIGHT;

func move():
	# Saves the last direction the snake moved
	last_direction = direction
	
	var has_grown = false;
	
	# Some variables
	var head : Vector2i = body[0];
	var tail : Vector2i = body[body.size() - 1];
	var next : Vector2i = head + direction_to_vector[direction];
	
	# Check for collisions with walls and with body
	if level_manager.get_cell(next) == BoardData.SNAKE\
	or level_manager.get_cell(next) == BoardData.WALL\
	or level_manager.get_cell(next) == BoardData.OUT_OF_BOUNDS:
		GameOver.emit();
		GlobalSignals.Tick.disconnect(move);
		return;
	
	# Adds a "new" head
	body.insert(0, next);
	
	# Checks if the player got any fruit
	if level_manager.get_cell(next) == BoardData.FRUIT:
		# Increases points
		points += 1;
		
		has_grown = true;
		
		# Emits a signal to spawn another one
		GlobalSignals.FruitWasEaten.emit(next);
	else:
		# If the snake didn't grow then erases the tail 
		body.remove_at(body.size() - 1);
		
		# Free cell in board manager
		level_manager.set_cell(tail, BoardData.EMPTY);
	
	# Occupy new cell in board manager
	level_manager.set_cell(next, BoardData.SNAKE)
	
	# Draws the new head
	snake_layer.set_cell(next, 0, Vector2i(0, 0));
	
	# Replaces the old head by a body
	snake_layer.set_cell(head, 0, Vector2i(1, 0));
	
	if(!has_grown):
		# Erases the tail
		snake_layer.erase_cell(tail);
