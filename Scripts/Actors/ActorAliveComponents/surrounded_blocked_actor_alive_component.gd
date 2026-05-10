extends BaseActorAliveComponent

class_name SurroundedBlockedActorAliveComponent

func is_alive():
	return !MovementUtil.get_surrounding_movements_for_actor(actor).is_empty();
