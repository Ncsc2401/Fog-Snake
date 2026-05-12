extends BaseActorAction

class_name MathActorAction

@export var a_key : String
@export var b_key : String
@export var c_key : String

@export var math_component : BaseMathComponent;
var l_math_component : BaseMathComponent;

## If true, then it will try to append the result on the c_key
@export var result_as_array : bool

func initialize(actor : Actor):
	super(actor)
	l_math_component = math_component.duplicate()
	l_math_component.initialize();

func can_do_action() -> bool:
	var value_a = actor.brain.get_from_brain(a_key)
	var value_b = actor.brain.get_from_brain(b_key)
	
	return math_component.can_do_action(value_a, value_b);

func do_action():
	var value_a = actor.brain.get_from_brain(a_key)
	var value_b = actor.brain.get_from_brain(b_key)
	
	var result = math_component.get_result(value_a, value_b);
	
	if result_as_array:
		var array_result = [result]
		if actor.brain.has_brain_key(c_key):
			var c = actor.brain.get_from_brain(c_key);
			if c is Array:
				for value in c:
					array_result.append(value);
		actor.brain.save_in_brain(c_key, array_result);
	else:
		actor.brain.save_in_brain(c_key, result);
