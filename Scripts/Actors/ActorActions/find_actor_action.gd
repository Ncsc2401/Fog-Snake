extends BaseActorAction

class_name FindActorAction

@export var find_component : BaseFindComponent
var l_find_component : BaseFindComponent

@export var appends : bool = false;

func initialize(actor : Actor):
	super(actor);
	
	l_find_component = find_component.duplicate();
	l_find_component.initialize(actor);

func can_do_action() -> bool:
	if !l_find_component.is_initialized:
		return false
	
	if l_find_component == null or !l_find_component.is_initialized:
		return false;
	
	return l_find_component.can_do_action();

func do_action():
	var brain_key = l_find_component.brain_key_to_store;
	var result = l_find_component.search();
	
	if appends and result is Array:
		var stored_values = actor.brain.get_from_brain_array(brain_key);
		for value in stored_values:
			if !result.has(value):
				result.append(value);
	
	actor.brain.save_in_brain(brain_key, result);
