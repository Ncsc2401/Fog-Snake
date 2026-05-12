extends BaseActorAction

class_name SetMemoryActorAction;

@export var set_component : BaseSetMemoryComponent;
var l_set_component : BaseSetMemoryComponent;

## If true the memory may be overwriten
@export var can_overwrite : bool = true;

## Brain key used to store the data;
@export var brain_key : String

func initialize(actor : Actor):
	super(actor)
	l_set_component = set_component.duplicate();
	l_set_component.initialize(actor);

func can_do_action() -> bool:
	if !can_overwrite and actor.brain.has_brain_key(brain_key):
		return false;
	
	return l_set_component.can_do_action();

func do_action():
	l_set_component.set_memory(brain_key);
