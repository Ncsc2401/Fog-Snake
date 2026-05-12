extends BaseSetMemoryComponent

class_name RandomDataSetMemoryComponent

enum ValueType{
	INT,
	FLOAT,
	BOOL,
	VECTOR2I,
	VECTOR2,
	CHOICE_POOL
}

@export var value_type : ValueType;

@export_subgroup("Array related")
## If true then the output will be an array of the given value type
@export var is_array : bool;

## Size of output array;
@export var array_size : int;

@export_subgroup("Number related")
@export var number_min : float = 0
@export var number_max : float = 1

@export_subgroup("Vector related")
@export var vector_min : Vector2 = Vector2.ZERO
@export var vector_max : Vector2 = Vector2.ONE

@export_subgroup("Choice Pool related")
@export var choice_pool : Array;

func can_do_action() -> bool:
	match value_type:
		ValueType.INT:
			if number_max <= number_min:
				return false;
			
			if ceil(number_min) - floor(number_max) <= 0:
				return false;
				
		ValueType.FLOAT:
			if number_max <= number_min:
				return false;
				
		ValueType.BOOL:
			return true;
		
		ValueType.VECTOR2I:
			if vector_max.x <= vector_min.x:
				return false;
			
			if vector_max.y <= vector_min.y:
				return false;
			
			if ceil(vector_min.x) - floor(vector_max.x) <= 0:
				return false;
			
			if ceil(vector_min.y) - floor(vector_max.y) <= 0:
				return false;
				
		ValueType.VECTOR2:
			if vector_max.x <= vector_min.x:
				return false;
			
			if vector_max.y <= vector_min.y:
				return false;
			
		ValueType.CHOICE_POOL:
			if choice_pool.is_empty():
				return false;
	
	return true;

func set_memory(brain_key : String):
	var value;
	
	if is_array:
		var array : Array = []
		for i in range(array_size):
			array.append(solve_value());
		
		value = array;
	
	else:
		value = solve_value();
	
	actor.brain.save_in_brain(brain_key, value);

func solve_value():
	match value_type:
		ValueType.INT:
			return get_random_int()
				
		ValueType.FLOAT:
			return get_random_float()
				
		ValueType.BOOL:
			return get_random_bool()
		
		ValueType.VECTOR2I:
			return get_random_vector2i()
			
		ValueType.VECTOR2:
			return get_random_vector2()
			
		ValueType.CHOICE_POOL:
			return get_random_choice()

func get_random_int():
	return randi_range(ceil(number_min), floor(number_max))

func get_random_float():
	return randf_range(number_min, number_max)

func get_random_bool():
	return randi_range(0, 1) == 1;

func get_random_vector2i():
	var x = randi_range(ceil(vector_min.x), floor(vector_max.x))
	var y = randi_range(ceil(vector_min.y), floor(vector_max.y))

	return Vector2i(x, y);

func get_random_vector2():
	var x = randf_range(vector_min.x, vector_max.x)
	var y = randf_range(vector_min.y, vector_max.y)

	return Vector2(x, y);

func get_random_choice():
	return choice_pool.pick_random();
