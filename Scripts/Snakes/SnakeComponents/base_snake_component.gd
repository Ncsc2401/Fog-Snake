@abstract
extends Resource

class_name BaseSnakeComponent;

var snake : Snake;
var is_initialized : bool = false;


func initialize(snake : Snake):
	self.snake = snake;
	is_initialized = true;
