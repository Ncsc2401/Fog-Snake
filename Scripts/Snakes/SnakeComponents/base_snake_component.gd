@abstract
extends Resource

class_name BaseSnakeComponent;

var snake : BaseSnake;
var is_initialized : bool = false;

func initialize(snake : BaseSnake):
	self.snake = snake;
	is_initialized = true;
