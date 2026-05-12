extends BaseActorAction

class_name GetDataActorAction

@export var get_data_component : BaseGetDataComponent
var l_get_data_component : BaseGetDataComponent

## Uses this key to save the overwritten data if any. 
## If this is null or empty, then the previus value is not saved.
@export var previous_value_key_backup : String

func initialize(actor : Actor):
	super(actor);
	l_get_data_component = get_data_component.duplicate();
	l_get_data_component.initialize(actor);

func can_do_action() -> bool:
	if !l_get_data_component.is_initialized:
		return false;
	
	return l_get_data_component.can_do_action();

func do_action():
	var brain_key : String = l_get_data_component.brain_key_to_store;

	var result = l_get_data_component.get_data();

	if previous_value_key_backup != null and !previous_value_key_backup.is_empty():
		if actor.brain.has_brain_key(brain_key):
			var previous_value = actor.brain.get_from_brain(brain_key);
			actor.brain.save_in_brain(previous_value_key_backup, previous_value);
	
	actor.brain.save_in_brain(brain_key, result);
