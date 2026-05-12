extends BaseActorAction

class_name ForgetActorAction

@export var forget_everything : bool

## The brain key that will be wiped. 
## Uselees if forget everything is true
@export var brain_key_to_forget : String

## The flag to check if it should be done. 
## If this exists and is not empty, then the brain key will only be erased if it is true
@export var brain_key_condition : String


func can_do_action() -> bool:
	if forget_everything:
		return true;
	
	if !brain_key_condition.is_empty() and actor.brain.has_brain_key(brain_key_condition):
		var condition = actor.brain.get_from_brain(brain_key_condition);
		if !condition:
			return false;
	
	return actor.brain.has_brain_key(brain_key_to_forget);

func do_action():
	if forget_everything:
		actor.brain.clear_brain()
	else:
		actor.brain.forget_key(ActorBrain.get_normalized_key(brain_key_to_forget));
