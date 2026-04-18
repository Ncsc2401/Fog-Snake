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

## Position where the player spawns
@export var initial_position : Vector2i;
## Initial direction the player starts
@export var initial_direction : Directions;

## Tile map layer where the snake is drawn
@export var snake_layer : TileMapLayer;
## Tile map layer where the wallsare drawn
@export var wall_layer : TileMapLayer;
## Tile map layer where the fruits are drawn
@export var fruit_layer : TileMapLayer;

## All tiles occupied by the snake
var body : Array[Vector2i];
## The direction the snake is currently moving towards
var direction : Directions;
## Last direction the snake moved
var last_direction : Directions;

## Size of the snake
var size : int = 1;

func _ready() -> void:
	if initial_direction == null:
		push_warning("No initial diretion setted")
		
	if initial_position == null:
		push_warning("No initial position setted")
	
	body.append(initial_position);
	direction = initial_direction;
	
	GlobalSignals.Tick.connect(move);

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
	
	# Some variables
	var head : Vector2i = body[0];
	var tail : Vector2i = body[body.size() - 1];
	var next : Vector2i = head + direction_to_vector[direction];
	
	# Check for collisions with walls and with body
	if wall_layer.get_cell_source_id(next) != -1 || body.has(next):
		GameOver.emit();
		GlobalSignals.Tick.disconnect(move);
		return;
	
	# Adds a "new" head
	body.insert(0, next);
	
	# Checks if the player got any fruit
	if fruit_layer.get_cell_source_id(next) != -1:
		# Increases size
		size += 1;
		
		# Emits a signal to spawn another one
		GlobalSignals.FruitWasEaten.emit();
		
		# Erases the collected fruit
		fruit_layer.erase_cell(next);
		
	else:
		# If the snake didn't grow then erases the tail 
		body.remove_at(body.size() - 1);
		
		# Erases the tail
		snake_layer.erase_cell(tail);
	
	# Draws the new head
	snake_layer.set_cell(head, 0, Vector2i(1, 0));
	
	# Replaces the old head by a body
	snake_layer.set_cell(body[0], 0, Vector2i(0, 0));
