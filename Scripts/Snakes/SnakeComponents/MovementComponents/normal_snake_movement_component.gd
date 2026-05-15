extends BaseSnakeMovementComponent

class_name NormalSnakeMovementComponent;

func move(move_direction : Snake.Directions):
	# Next pos it will move
	var next : Vector2i = snake.head.pos + snake.direction_to_vector[move_direction]
	
	# Move every body data
	snake.last_tail_pos = snake.tail.pos;
	var body_segment = snake.tail
	while body_segment.previous != null:
		body_segment.pos = body_segment.previous.pos
		body_segment = body_segment.previous
	snake.head.pos = next
