extends Node2D

class_name Snake

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
@export var initial_direction : Directions;

## Board manager reference
@export var level_manager : LevelManager;

## Tile map layer where the snake is drawn
@onready var snake_layer: TileMapLayer = $SnakeLayer

## Sound controller works fine without one
@onready var sound_controller: SoundController = $SoundController

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

## All tiles occupied by the snake
var occupied_spaces : Array[Vector2i];

## Head of snake
var head : BodyData;
## Tail of snake
var tail : BodyData;

## Size the snake should have
var expected_size : int = 0;

## Size the snake has
var body_size : int = 0;

func _ready() -> void:
	await get_tree().process_frame
	
	if level_manager == null:
		push_error("Cannot work without a board manager reference");
		
	if initial_body == null:
		push_warning("No initial body set")
	
	for body_part in initial_body:
		if level_manager.get_cell(body_part) != BoardData.EMPTY:
			push_warning("Snake spawning inside occupied cell");
	
	occupied_spaces = initial_body.duplicate();
	
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
		tail = last_segment;
	
	direction = initial_direction;
	last_direction = initial_direction;
	body_size = initial_body.size();
	expected_size = body_size;
	
	GlobalSignals.Tick.connect(move);
	
	draw_snake()

func _process(delta: float) -> void:
	update_buffer_lifetime(delta);

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Down"):
		add_direction_to_buffer(Directions.DOWN)
	if event.is_action_pressed("Up"):
		add_direction_to_buffer(Directions.UP)
	if event.is_action_pressed("Left"):
		add_direction_to_buffer(Directions.LEFT)
	if event.is_action_pressed("Right"):
		add_direction_to_buffer(Directions.RIGHT)

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

## Draws snake from tail to head so everything is drawn in the right order
func draw_snake():
	var body_segment = tail;
	
	while body_segment != null:
		var atlas_coord : Vector2i;
		var alternative : int
		
		# Tail case
		if body_segment.is_tail:
			atlas_coord = Vector2i(3, 0);
			match body_segment.get_previous_direction():
				Directions.LEFT:
					alternative = 0;
				Directions.RIGHT:
					alternative = 2
				Directions.UP:
					alternative = 1
				Directions.DOWN:
					alternative = 3
		
		# Head case
		elif body_segment.is_head:
			atlas_coord = Vector2i(0, 0);
			match direction:
				Directions.LEFT:
					alternative = 2;
				Directions.RIGHT:
					alternative = 0
				Directions.UP:
					alternative = 3
				Directions.DOWN:
					alternative = 1
		
		# Body case
		else:
			# Is straigth
			if body_segment.get_previous_direction() == flipped_direction[body_segment.get_next_direction()]:
				atlas_coord = Vector2i(1, 0)
				
				match body_segment.get_next_direction():
					Directions.UP, Directions.DOWN:
						alternative = 1;
					Directions.LEFT, Directions.RIGHT:
						alternative = 0;
			
			# Is curved
			else:
				atlas_coord = Vector2i(2, 0)
				
				var from = body_segment.get_previous_direction()
				var to   = body_segment.get_next_direction()
				match [from, to]:
					[Directions.LEFT, Directions.UP]:
						alternative = 0
					[Directions.UP, Directions.LEFT]:
						alternative = 0
					[Directions.LEFT, Directions.DOWN]:
						alternative = 1
					[Directions.DOWN, Directions.LEFT]:
						alternative = 1
					[Directions.DOWN, Directions.RIGHT]:
						alternative = 2
					[Directions.RIGHT, Directions.DOWN]:
						alternative = 2
					[Directions.UP, Directions.RIGHT]:
						alternative = 3
					[Directions.RIGHT, Directions.UP]:
						alternative = 3
		
		snake_layer.set_cell(body_segment.position, 0, atlas_coord, alternative);
		body_segment = body_segment.previous;

## Clears snake tilemap
func clear_snake():
	snake_layer.clear()

func move():
	print(level_manager.board);
	
	play_movement_sounds()
	
	# Saves the last direction the snake moved
	last_direction = direction
	
	# Get new direction
	var possible_movement : Directions
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
	
	# Needed variable to grow
	var tail_pos_before_mov = tail.position
	
	# Next position it will move
	var next : Vector2i = head.position + direction_to_vector[direction];
	
	# Adds a "new" head
	occupied_spaces.insert(0, next);
	
	# Move every body data
	var body_segment = tail
	while body_segment.previous != null:
		body_segment.position = body_segment.previous.position
		body_segment = body_segment.previous
	head.position = next
	
	# Decide first, do later
	var will_die : bool = false;
	var has_fruit : bool = false;
	
	# Checks if the player got any fruit
	if level_manager.get_cell(next) == BoardData.FRUIT:
		has_fruit = true;
	
	# Check for collisions with walls and with body
	if (level_manager.get_cell(next) == BoardData.SNAKE\
	or level_manager.get_cell(next) == BoardData.WALL\
	or level_manager.get_cell(next) == BoardData.OUT_OF_BOUNDS)\
	and (next != tail_pos_before_mov and expected_size == body_size):
		will_die = true;
	
	# Occupy new cell in board manager
	level_manager.set_cell(next, BoardData.SNAKE)
	
	if will_die:
		GameOver.emit();
		GlobalSignals.Tick.disconnect(move);
		return;
	
	if has_fruit:
		var fruit : FruitResource = level_manager.eat_fruit(next);
		
		# Play sound
		sound_controller.play_sound("grow")
		
		# Increase size
		expected_size += fruit.size_increase;
	
	if expected_size > body_size:
		# Creates a new body segment
		var new_body_segment = BodyData.new(false, true, tail_pos_before_mov);
		new_body_segment.previous = tail;
		tail.is_tail = false;
		tail.next = new_body_segment;
		tail = new_body_segment;
		body_size += 1;
	else:
		# If the snake didn't grow then erases the tail 
		occupied_spaces.remove_at(occupied_spaces.size() - 1);
		
		# Free tail cell in board manager final
		if level_manager.get_cell(tail_pos_before_mov) == BoardData.SNAKE:
			level_manager.set_cell(tail_pos_before_mov, BoardData.EMPTY);
	
	# Occupy new cell in board manager in case tail erased it
	level_manager.set_cell(next, BoardData.SNAKE)
	
	snake_layer.clear()
	draw_snake()
