extends BaseActorAction

class_name ClearWarningsActorAction

func can_do_action() -> bool:
	var warning_layer = actor.brain.get_from_brain("WarningLayer");
	
	if warning_layer == null or warning_layer is not TileMapLayer:
		return false;
	
	return true;

func do_action():
	var warning_layer : TileMapLayer = actor.brain.get_from_brain("WarningLayer");
	
	warning_layer.clear()
