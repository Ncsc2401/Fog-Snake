extends BaseActorAction

class_name ChooseActorAction

@export var choose_component : BaseChooseComponent
var l_choose_component : BaseChooseComponent;

func initialize(actor : Actor):
	super(actor);
	l_choose_component = choose_component.duplicate();
	l_choose_component.initialize(actor);

func can_do_action() -> bool:
	return l_choose_component.can_do_action();

func do_action():
	var result = l_choose_component.choose();
	
	actor.brain.save_in_brain(l_choose_component.brain_key_to_store, result);
