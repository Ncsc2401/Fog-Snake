extends Node2D

class_name BaseSnake

signal GameOver()

class BodyData:
	var is_head : bool;
	var is_tail : bool;
	
	var pos : Vector2i;
	var next : BodyData;
	var previous : BodyData;
	
	func _init(is_head : bool, is_tail : bool, pos : Vector2i) -> void:
		self.is_head = is_head;
		self.is_tail = is_tail;
		self.pos = pos;
	
	func get_next_relative_pos() -> Vector2i:
		return next.pos - pos;
	
	func get_previous_relative_pos() -> Vector2i:
		return previous.pos - pos;

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

## Converts vector to enum direction
var vector_to_direction : Dictionary = {
	Vector2i(-1, 0) : Directions.LEFT,
	Vector2i(1, 0) : Directions.RIGHT,
	Vector2i(0, 1) : Directions.DOWN,
	Vector2i(0, -1) : Directions.UP,
}

var direction_to_angle : Dictionary[Directions, float] = {
	Directions.RIGHT : 0,
	Directions.UP : 3 * PI / 2,
	Directions.LEFT : PI,
	Directions.DOWN : PI / 2
}

## Initial snake body, index 0 is the head
@export var initial_body : Array[Vector2i];

## Initial direction the player starts
@export var initial_direction : Directions = Directions.RIGHT;

## Board manager reference
@export var level_manager : LevelManager;

## Tile map layer where the snake is drawn
@export var snake_layer: TileMapLayer;

@export_subgroup("Sound Related")
@export var sound_controller : SoundController;
@export var makes_move_sounds : bool = true;

@export_subgroup("Components")
@export var death_component : BaseSnakeDeathComponent;
@export var draw_component : BaseSnakeDrawComponent
@export var movement_component : BaseSnakeMovementComponent;
@export var grow_component : BaseSnakeGrowComponent;
@export var eat_component : BaseSnakeEatComponent;
@export var input_component : BaseSnakeInputComponent;
@export var misc_components : Array[BaseSnakeMiscComponent];


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
	
	# Initializate body data
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
	
	# Initial status
	direction = initial_direction;
	last_direction = initial_direction;
	body_size = initial_body.size();
	expected_size = body_size;
	
	# Component initialization
	death_component.initialize(self);
	draw_component.initialize(self);
	movement_component.initialize(self);
	grow_component.initialize(self);
	eat_component.initialize(self);
	input_component.initialize(self);
	
	for misc_component in misc_components:
		misc_component.initialize(self);
	
	# Set tile set
	snake_layer.tile_set = draw_component.snake_tileset;
	
	# Draw
	draw_component.draw();

func _process(delta: float) -> void:
	update_buffer_lifetime(delta);
	
	for misc_component in misc_components:
		if misc_component.is_initialized:
			misc_component.on_process(delta);

func _input(event: InputEvent) -> void:
	if input_component.is_initialized:
		input_component.handle_input(event);

func snake_layer_to_global_pos(tilemap_pos : Vector2i) -> Vector2:
	return snake_layer.to_global(snake_layer.map_to_local(tilemap_pos));

## Adds a direction to the buffer. Acts as an input buffer for directions
func add_direction_to_buffer(dir : Directions):
	var direction_buffer_data = DirectionBufferData.new(dir)
	
	direction_buffer.append(direction_buffer_data);
	
	if direction_buffer.size() >= MAX_DIRECTION_BUFFER_SIZE:
		direction_buffer.remove_at(0);

## Manages input buffer lifetime
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

func play_movement_sounds():
	if sound_controller == null:
		print("Missing sound controller");
		return
	
	if direction == Directions.UP && last_direction != Directions.UP:
		sound_controller.play_sound("Up")
	elif direction == Directions.LEFT && last_direction != Directions.LEFT:
		sound_controller.play_sound("Left")
	elif direction == Directions.DOWN && last_direction != Directions.DOWN:
		sound_controller.play_sound("Down")
	elif direction == Directions.RIGHT && last_direction != Directions.RIGHT:
		sound_controller.play_sound("Right")

func draw_snake():
	if is_dead:
		return;
	
	if draw_component.is_initialized:
		draw_component.draw()

func move():
	if is_dead:
		return;
	
	# Saves the last direction the snake moved
	last_direction = direction
	
	# Get new direction
	var possible_movement : Directions = Directions.RIGHT
	var got_possible_movement : bool = false;
	while direction_buffer.size() > 0 && !got_possible_movement:
		possible_movement = direction_buffer.pop_front().direction;
			
		if possible_movement == direction:
			continue;
			
		if possible_movement == flipped_direction[direction]:
			continue;
		got_possible_movement = true;
	if got_possible_movement:
		direction = possible_movement
	
	if movement_component.is_initialized:
		movement_component.move(direction);
	
	for misc_component in misc_components:
		if misc_component.is_initialized:
			misc_component.on_move(direction);

func die():
	if is_dead:
		return
	
	if death_component.is_initialized:
		death_component.die();
	
	for misc_component in misc_components:
		if misc_component.is_initialized:
			misc_component.on_death();

func eat_fruit(fruit_resource : FruitResource):
	if is_dead:
		return;
	
	if eat_component.is_initialized:
		eat_component.eat(fruit_resource)
		
	for misc_component in misc_components:
		if misc_component.is_initialized:
			misc_component.on_eat(fruit_resource)

func grow():
	if is_dead:
		return
	
	if grow_component.is_initialized:
		grow_component.grow();
