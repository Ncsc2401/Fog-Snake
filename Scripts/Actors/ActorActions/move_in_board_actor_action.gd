extends BaseActorAction

class_name MoveInBoardActorAction

func can_do_action() -> bool:
	var next_board_movement = actor.brain.get_from_brain(ActorBrain.NEXT_BOARD_MOVEMENT);
		
	if next_board_movement == null or !actor.level_manager.is_space_empty(next_board_movement):
		return false;
	
	return true;

func do_action():
	var next_board_movement = actor.brain.get_from_brain(ActorBrain.NEXT_BOARD_MOVEMENT)
	
	actor.board_position = next_board_movement;
	actor.global_position = actor.reference_tilemap.to_global(actor.reference_tilemap.map_to_local(next_board_movement));
