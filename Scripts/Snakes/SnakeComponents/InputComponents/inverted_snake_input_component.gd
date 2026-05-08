extends BaseSnakeInputComponent

class_name InvertedSnakeInputComponent

func handle_input(event : InputEvent):
	if event.is_action_pressed("Down"):
		snake.add_direction_to_buffer(BaseSnake.Directions.UP)
	if event.is_action_pressed("Up"):
		snake.add_direction_to_buffer(BaseSnake.Directions.DOWN)
	if event.is_action_pressed("Left"):
		snake.add_direction_to_buffer(BaseSnake.Directions.RIGHT)
	if event.is_action_pressed("Right"):
		snake.add_direction_to_buffer(BaseSnake.Directions.LEFT)
