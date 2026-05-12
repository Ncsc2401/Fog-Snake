@abstract
extends Resource

class_name BaseMathComponent

var is_initialized: bool = false;

func initialize():
	is_initialized = true;

@abstract
func can_do_action(value_a, value_b)

@abstract
func get_result(value_a, value_b)
