extends BaseActorAction

class_name TickChangeActorAction

@export var new_tick : int;

## The flag to check if it should be done. 
## If this exists and is not empty, then the tick will ony be changed if it is true
@export var brain_key_condition : String

func can_do_action() -> bool:
	if brain_key_condition == null or brain_key_condition.is_empty():
		return false;
	
	return new_tick >= 0;

func do_action():
	actor.request_tick_change(new_tick);
