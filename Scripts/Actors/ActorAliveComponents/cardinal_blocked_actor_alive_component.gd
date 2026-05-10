extends BaseActorAliveComponent

class_name CardinalBlockedActorAliveComponent

func is_alive():
	return !MovementUtil.get_cardinal_movements_for_actor(actor).is_empty()
