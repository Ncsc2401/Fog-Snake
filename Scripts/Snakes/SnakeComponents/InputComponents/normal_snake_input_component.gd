extends BaseSnakeInputComponent

class_name NormalSnakeInputComponent

func handle_input(event : InputEvent):
	if event.is_action_pressed("Down"):
		snake.add_direction_to_buffer(Snake.Directions.DOWN)
	if event.is_action_pressed("Up"):
		snake.add_direction_to_buffer(Snake.Directions.UP)
	if event.is_action_pressed("Left"):
		snake.add_direction_to_buffer(Snake.Directions.LEFT)
	if event.is_action_pressed("Right"):
		snake.add_direction_to_buffer(Snake.Directions.RIGHT)
