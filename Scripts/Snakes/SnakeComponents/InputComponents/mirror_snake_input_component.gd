extends BaseSnakeInputComponent

class_name MirrorSnakeInputComponent

enum MirrorAxis {
	X_AXIS,
	Y_AXIS
}

@export var mirror_axis : MirrorAxis = MirrorAxis.X_AXIS

func handle_input(event : InputEvent):
	if event.is_action_pressed("Down"):
		if mirror_axis == MirrorAxis.X_AXIS:
			snake.add_direction_to_buffer(Snake.Directions.UP)
		else:
			snake.add_direction_to_buffer(Snake.Directions.DOWN)
	if event.is_action_pressed("Up"):
		if mirror_axis == MirrorAxis.X_AXIS:
			snake.add_direction_to_buffer(Snake.Directions.DOWN)
		else:
			snake.add_direction_to_buffer(Snake.Directions.UP)
	if event.is_action_pressed("Left"):
		if mirror_axis == MirrorAxis.Y_AXIS:
			snake.add_direction_to_buffer(Snake.Directions.RIGHT)
		else:
			snake.add_direction_to_buffer(Snake.Directions.LEFT)
	if event.is_action_pressed("Right"):
		if mirror_axis == MirrorAxis.Y_AXIS:
			snake.add_direction_to_buffer(Snake.Directions.LEFT)
		else:
			snake.add_direction_to_buffer(Snake.Directions.RIGHT)
