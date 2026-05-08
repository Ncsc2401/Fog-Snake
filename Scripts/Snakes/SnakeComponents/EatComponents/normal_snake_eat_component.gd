extends BaseSnakeEatComponent

class_name NormalSnakeEatComponent

func eat(fruit_resource : FruitResource):
	if snake.sound_controller:
		snake.sound_controller.play_sound("grow");
	else:
		push_warning("Snake missing sound controller");
		
	snake.expected_size += fruit_resource.size_increase;
