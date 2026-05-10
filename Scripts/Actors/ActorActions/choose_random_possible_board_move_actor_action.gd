extends BaseActorAction

class_name ChooseRandomPossibleBoardMoveActorAction

func can_do_action() -> bool:
	var possible_movements = actor.brain.get_from_brain(ActorBrain.POSSIBLE_BOARD_MOVEMENTS);
	
	if possible_movements == null or possible_movements.is_empty():
		return false;
	
	return true;

func do_action():
	var possible_movements : Array = actor.brain.get_from_brain(ActorBrain.POSSIBLE_BOARD_MOVEMENTS);
	
	var next_movement = possible_movements.pick_random();
	
	actor.brain.save_in_brain(ActorBrain.NEXT_BOARD_MOVEMENT, next_movement);
