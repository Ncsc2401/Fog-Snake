extends BaseActorAction

class_name FindFreeBoardSpacesActorAction

func can_do_action() -> bool:
	return true;

func do_action():
	var possible_movements = actor.level_manager.get_empty_spaces();
	actor.brain.save_in_brain(ActorBrain.POSSIBLE_BOARD_MOVEMENTS, possible_movements);
