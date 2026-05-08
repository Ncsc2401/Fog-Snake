extends BaseSnakeGrowComponent

class_name NormalSnakeGrowComponent

func grow():
	if snake.expected_size > snake.body_size:
		# Creates a new body segment
		var new_body_segment = snake.BodyData.new(false, true, snake.last_tail_pos);
		new_body_segment.previous = snake.tail;
		snake.tail.is_tail = false;
		snake.tail.next = new_body_segment;
		snake.tail = new_body_segment;
		snake.body_size += 1;
		snake.snake_body.append(new_body_segment);
