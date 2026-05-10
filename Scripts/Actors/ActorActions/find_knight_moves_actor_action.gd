extends BaseActorAction

class_name FindKnightMovesActorActions

## If the action should append to possible movements or overwrite it
@export var appends : bool

func can_do_action() -> bool:
	return true;

func do_action():
	var possible_movements = MovementUtil.get_knight_movements_for_actor(actor);
	
	if appends:
		var saved_possible_movements = actor.brain.get_from_brain(ActorBrain.POSSIBLE_BOARD_MOVEMENTS)
		if saved_possible_movements != null and saved_possible_movements is Array:
			for saved_possible_movement in saved_possible_movements:
				if possible_movements.has(saved_possible_movement):
					continue;
				
				possible_movements.append(saved_possible_movement)
	
	actor.brain.save_in_brain(ActorBrain.POSSIBLE_BOARD_MOVEMENTS, possible_movements);
