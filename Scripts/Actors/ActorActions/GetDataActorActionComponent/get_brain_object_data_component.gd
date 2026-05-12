extends BaseGetDataComponent

class_name GetBrainObjectDataComponent

## The holder of the data you want to access
@export var data_holder_brain_key : String

## The data path
@export var data_path : StringName

func set_brain_key_to_store():
	brain_key_to_store = custom_key_value

func can_do_action() -> bool:
	if !has_custom_key_value():
		return false;
	
	if !actor.brain.has_brain_key(data_holder_brain_key):
		return false;
	
	var data_holder = actor.brain.get_from_brain(data_holder_brain_key)
	
	if !is_instance_valid(data_holder):
		return false;
	
	if !data_holder.has(data_path):
		return false;
	
	return true;

func get_data():
	var data_holder = actor.brain.get_from_brain(data_holder_brain_key)
	
	return data_holder.get(data_path)
