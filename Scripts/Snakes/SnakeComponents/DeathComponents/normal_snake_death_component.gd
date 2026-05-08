extends BaseSnakeDeathComponent

class_name NormalSnakeDeathComponent

func die():
	snake.is_dead = true;
	snake.GameOver.emit();
