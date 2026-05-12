extends BaseSetMemoryComponent

class_name FromMemorySetMemoryComponent

# Where data with be gather
@export var brain_key_source : String

func can_do_action() -> bool:
	return actor.brain.has_brain_key(brain_key_source);

func set_memory(brain_key : String):
	var value = actor.brain.get_from_brain(brain_key_source);
	actor.brain.save_in_brain(brain_key, value);
