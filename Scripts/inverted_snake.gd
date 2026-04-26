extends NormalSnake

class_name InvertedSnake

func input_handler(event: InputEvent) -> void:
	if event.is_action_pressed("Down"):
		add_direction_to_buffer(Directions.UP)
	if event.is_action_pressed("Up"):
		add_direction_to_buffer(Directions.DOWN)
	if event.is_action_pressed("Left"):
		add_direction_to_buffer(Directions.RIGHT)
	if event.is_action_pressed("Right"):
		add_direction_to_buffer(Directions.LEFT)
