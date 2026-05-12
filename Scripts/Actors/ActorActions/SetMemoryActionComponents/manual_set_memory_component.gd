extends BaseSetMemoryComponent

class_name ManualSetMemoryComponent

@export var value : Variant

func can_do_action() -> bool:
	return true;

func set_memory(brain_key : String):
	actor.brain.save_in_brain(brain_key, value);
