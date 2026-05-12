extends BaseSnakeDrawComponent

class_name DefaultSnakeDrawComponent

func draw():
	var body_segment = snake.tail;
	
	while body_segment != null:
		var atlas_coord : Vector2i;
		var alternative : int
		
		# Tail case
		if body_segment.is_tail:
			atlas_coord = Vector2i(3, 0);
			
			var previous_pos = body_segment.get_previous_relative_pos();
			
			if !snake.vector_to_direction.has(previous_pos):
				push_warning("Invalid tail dir")
				continue;
			
			var previous_dir = snake.vector_to_direction[previous_pos];
			
			match previous_dir:
				Snake.Directions.LEFT:
					alternative = 0;
				Snake.Directions.RIGHT:
					alternative = 2
				Snake.Directions.UP:
					alternative = 1
				Snake.Directions.DOWN:
					alternative = 3
		
		# Head case
		elif body_segment.is_head:
			
			atlas_coord = Vector2i(0, 0);
			
			var neg_next_pos = -body_segment.get_next_relative_pos();
			
			if !snake.vector_to_direction.has(neg_next_pos):
				push_warning("Invalid head dir");
			
			var neg_next_dir = snake.vector_to_direction[neg_next_pos];
			
			match neg_next_dir:
				Snake.Directions.LEFT:
					alternative = 2;
				Snake.Directions.RIGHT:
					alternative = 0
				Snake.Directions.UP:
					alternative = 3
				Snake.Directions.DOWN:
					alternative = 1
		
		# Body case
		else:
			# Is straigth
			if body_segment.get_previous_relative_pos() == -body_segment.get_next_relative_pos():
				atlas_coord = Vector2i(1, 0)
				
				var next_pos = body_segment.get_next_relative_pos();
				
				if !snake.vector_to_direction.has(next_pos):
					push_warning("Invalid body dir")
					continue;
				
				var next_dir = snake.vector_to_direction[next_pos]
				
				match next_dir:
					Snake.Directions.UP, Snake.Directions.DOWN:
						alternative = 1;
					Snake.Directions.LEFT, Snake.Directions.RIGHT:
						alternative = 0;
			
			# Is curved
			else:
				atlas_coord = Vector2i(2, 0)
				
				var from_pos = body_segment.get_previous_relative_pos();
				var to_pos = body_segment.get_next_relative_pos();
				
				if !snake.vector_to_direction.has(from_pos) or !snake.vector_to_direction.has(to_pos):
					push_warning("Invalid body dir");
					continue;
				
				var from = snake.vector_to_direction[from_pos]
				var to = snake.vector_to_direction[to_pos]
				
				match [from, to]:
					[Snake.Directions.LEFT, Snake.Directions.UP]:
						alternative = 0
					[Snake.Directions.UP, Snake.Directions.LEFT]:
						alternative = 0
					[Snake.Directions.LEFT, Snake.Directions.DOWN]:
						alternative = 1
					[Snake.Directions.DOWN, Snake.Directions.LEFT]:
						alternative = 1
					[Snake.Directions.DOWN, Snake.Directions.RIGHT]:
						alternative = 2
					[Snake.Directions.RIGHT, Snake.Directions.DOWN]:
						alternative = 2
					[Snake.Directions.UP, Snake.Directions.RIGHT]:
						alternative = 3
					[Snake.Directions.RIGHT, Snake.Directions.UP]:
						alternative = 3
		
		snake.snake_layer.set_cell(body_segment.pos, 0, atlas_coord, alternative);
		body_segment = body_segment.previous;
