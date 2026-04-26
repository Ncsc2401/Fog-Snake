@abstract
extends Node2D

class_name BaseSnake

signal GameOver()

class BodyData:
	var is_head : bool;
	var is_tail : bool;
	
	var position : Vector2i;
	var next : BodyData;
	var previous : BodyData;
	
	## Converts vector to enum direction
	var vector_to_direction : Dictionary = {
		Vector2i(-1, 0) : Directions.LEFT,
		Vector2i(1, 0) : Directions.RIGHT,
		Vector2i(0, 1) : Directions.DOWN,
		Vector2i(0, -1) : Directions.UP,
	}
	
	
	func _init(is_head : bool, is_tail : bool, position : Vector2i) -> void:
		self.is_head = is_head;
		self.is_tail = is_tail;
		self.position = position;
	
	func get_next_direction() -> Directions:
		return vector_to_direction[next.position - position];
		
	
	func get_previous_direction():
		return vector_to_direction[previous.position - position]

class DirectionBufferData:
	var life_time;
	var direction : Directions;
	
	func _init(direction : Directions):
		life_time = 0;
		self.direction = direction;

## Directions the snake can move.
enum Directions {
	LEFT = 1,
	RIGHT = 2,
	UP = 4,
	DOWN = 8,
}

var flipped_direction : Dictionary = {
	Directions.LEFT : Directions.RIGHT,
	Directions.RIGHT : Directions.LEFT,
	Directions.UP : Directions.DOWN,
	Directions.DOWN : Directions.UP
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
@export var initial_direction : Directions = Directions.RIGHT;

## Board manager reference
@export var level_manager : LevelManager;

## Tile map layer where the snake is drawn
@export var snake_layer: TileMapLayer;

## How many keys are saved
const MAX_DIRECTION_BUFFER_SIZE = 3;

## Lifetime of direction buffer
const DIRECTION_BUFFER_LIFETIME = 0.35;

## Works like an input buffer
var direction_buffer : Array[DirectionBufferData];

## Direction moved
var direction : Directions

## Previous direction the snake moved
var last_direction : Directions;

var snake_body : Array[BodyData] = []

## Head of snake
var head : BodyData;
## Tail of snake
var tail : BodyData;

## Last tail space
var last_tail_pos : Vector2i;

## Size the snake should have
var expected_size : int = 0;

## Size the snake has
var body_size : int = 0;

var is_dead : bool = false;

func _ready() -> void:
	await get_tree().process_frame
	
	level_manager.snakes.append(self);
	
	if level_manager == null:
		push_error("Cannot work without a board manager reference");
		
	if initial_body == null:
		push_warning("No initial body set")
	
	var last_segment : BodyData
	for i in range(initial_body.size()):
		var body_data = BodyData.new(i == 0, i == initial_body.size() - 1, initial_body[i]);
		if head == null:
			head = body_data;
			last_segment = head;
			head.previous = null;
		else:
			body_data.previous = last_segment;
			last_segment.next = body_data;
			last_segment = body_data;
		
		snake_body.append(body_data);
		tail = last_segment;
	
	direction = initial_direction;
	last_direction = initial_direction;
	body_size = initial_body.size();
	expected_size = body_size;
	
	draw_snake()

func _process(delta: float) -> void:
	update_buffer_lifetime(delta);

func _input(event: InputEvent) -> void:
	input_handler(event);

func add_direction_to_buffer(dir : Directions):
	var direction_buffer_data = DirectionBufferData.new(dir)
	
	direction_buffer.append(direction_buffer_data);
	
	if direction_buffer.size() >= MAX_DIRECTION_BUFFER_SIZE:
		direction_buffer.remove_at(0);

func update_buffer_lifetime(delta : float):
	var indeces_to_remove : Array[int]
	for i in range(direction_buffer.size()):
		var dir_buf_data = direction_buffer[i];
		dir_buf_data.life_time += delta;
		if dir_buf_data.life_time > DIRECTION_BUFFER_LIFETIME:
			indeces_to_remove.append(i);
	
	indeces_to_remove.sort()
	indeces_to_remove.reverse()
	for i in indeces_to_remove:
		direction_buffer.remove_at(i);

## Clears snake tilemap if snake is alive
func clear_snake():
	if is_dead:
		return;
	snake_layer.clear()

## Clears snake tilemap
func force_clear_snake():
	snake_layer.clear()

@abstract
func input_handler(event : InputEvent);

@abstract
func draw_snake();

@abstract
func move();

@abstract
func die();

@abstract
func eat_fruit(fruit_resource : FruitResource);

@abstract
func grow();
