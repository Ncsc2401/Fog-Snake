extends BaseSnakeEatComponent

class_name NormalSnakeEatComponent

func eat(fruit_resource : FruitResource):
	snake.expected_size += fruit_resource.size_increase;
