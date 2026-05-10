extends BaseActorAliveComponent

class_name KnightBlockedActorAliveComponent

func is_alive():
	return !MovementUtil.get_knight_movements_for_actor(actor).is_empty()
