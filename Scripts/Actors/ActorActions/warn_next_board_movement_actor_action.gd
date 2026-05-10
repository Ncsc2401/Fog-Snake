extends BaseActorAction

class_name WarnNextBoardMovementActorAction

func can_do_action() -> bool:
	if !actor.brain.has_brain_key(ActorBrain.NEXT_BOARD_MOVEMENT):
		return false
	
	if !actor.brain.has_brain_key("WarningSource"):
		return false
	
	if !actor.brain.has_brain_key("WarningAtlasCoordinate"):
		return false
	
	var warning_layer = actor.brain.get_from_brain("WarningLayer");
	
	if warning_layer == null or warning_layer is not TileMapLayer:
		return false;
	
	return true;

func do_action():
	var warning_layer : TileMapLayer = actor.brain.get_from_brain("WarningLayer");
	var warning_atlas_coordinate : Vector2i = actor.brain.get_from_brain("WarningAtlasCoordinate");
	var warning_source : int = actor.brain.get_from_brain("WarningSource");
	
	var next_board_movement = actor.brain.get_from_brain(ActorBrain.NEXT_BOARD_MOVEMENT)
	
	warning_layer.set_cell(next_board_movement, warning_source, warning_atlas_coordinate);
