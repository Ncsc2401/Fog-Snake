extends BaseSnake

class_name NormalSnake

@onready var sound_controller: SoundController = $SoundController

@export var makes_move_sounds : bool = true;

func input_handler(event: InputEvent) -> void:
	if event.is_action_pressed("Down"):
		add_direction_to_buffer(Directions.DOWN)
	if event.is_action_pressed("Up"):
		add_direction_to_buffer(Directions.UP)
	if event.is_action_pressed("Left"):
		add_direction_to_buffer(Directions.LEFT)
	if event.is_action_pressed("Right"):
		add_direction_to_buffer(Directions.RIGHT)

func play_movement_sounds():
	if !makes_move_sounds:
		return;
	
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

## Draws snake from tail to head so everything is drawn in the right order
func draw_snake():
	if is_dead:
		return
		
	var body_segment = tail;
	
	while body_segment != null:
		var atlas_coord : Vector2i;
		var alternative : int
		
		# Tail case
		if body_segment.is_tail:
			atlas_coord = Vector2i(3, 0);
			
			var previous_pos = body_segment.get_previous_relative_pos();
			
			if !vector_to_direction.has(previous_pos):
				push_warning("Invalid tail dir")
				continue;
			
			var previous_dir = vector_to_direction[previous_pos];
			
			match previous_dir:
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
			
			var neg_next_pos = -body_segment.get_next_relative_pos();
			
			if !vector_to_direction.has(neg_next_pos):
				push_warning("Invalid head dir");
			
			var neg_next_dir = vector_to_direction[neg_next_pos];
			
			match neg_next_dir:
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
			if body_segment.get_previous_relative_pos() == -body_segment.get_next_relative_pos():
				atlas_coord = Vector2i(1, 0)
				
				var next_pos = body_segment.get_next_relative_pos();
				
				if !vector_to_direction.has(next_pos):
					push_warning("Invalid body dir")
					continue;
				
				var next_dir = vector_to_direction[next_pos]
				
				match next_dir:
					Directions.UP, Directions.DOWN:
						alternative = 1;
					Directions.LEFT, Directions.RIGHT:
						alternative = 0;
			
			# Is curved
			else:
				atlas_coord = Vector2i(2, 0)
				
				var from_pos = body_segment.get_previous_relative_pos();
				var to_pos = body_segment.get_next_relative_pos();
				
				if !vector_to_direction.has(from_pos) or !vector_to_direction.has(to_pos):
					push_warning("Invalid body dir");
					continue;
				
				var from = vector_to_direction[from_pos]
				var to = vector_to_direction[to_pos]
				
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
		
		snake_layer.set_cell(body_segment.pos, 0, atlas_coord, alternative);
		body_segment = body_segment.previous;

func move():
	if is_dead:
		return;
	play_movement_sounds()
	
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
	
	# Next pos it will move
	var next : Vector2i = head.pos + direction_to_vector[direction];
	
	# Move every body data
	last_tail_pos = tail.pos;
	var body_segment = tail
	while body_segment.previous != null:
		body_segment.pos = body_segment.previous.pos
		body_segment = body_segment.previous
	head.pos = next

func die():
	is_dead = true;
	GameOver.emit();

func eat_fruit(fruit_resource : FruitResource):
	if is_dead:
		return
	
	sound_controller.play_sound("grow");
	expected_size += fruit_resource.size_increase;

func grow():
	if is_dead:
		return
	
	if expected_size > body_size:
		# Creates a new body segment
		var new_body_segment = BodyData.new(false, true, last_tail_pos);
		new_body_segment.previous = tail;
		tail.is_tail = false;
		tail.next = new_body_segment;
		tail = new_body_segment;
		body_size += 1;
		snake_body.append(new_body_segment);
