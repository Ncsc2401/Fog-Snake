@abstract
extends Resource

class_name BaseFruitEatComponent

var is_initialized : bool = false;
var fruit : Fruit;

func initialize(fruit : Fruit):
	self.fruit = fruit;
	is_initialized = true;

@abstract
func on_eat()
