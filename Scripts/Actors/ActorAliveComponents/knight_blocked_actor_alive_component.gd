extends BaseActorAliveComponent

class_name KnightBlockedActorAliveComponent

func is_alive():
	return !MovementUtil\
	.get_knight_movements_for_pos(actor.board_position)\
	.filter(func(pos): return actor.level_manager.is_space_empty(pos))\
	.is_empty()
