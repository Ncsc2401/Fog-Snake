extends BaseWinCondition

class_name PointsWinCondition

@export var points_to_win : int = -1

func check_win() -> bool:	
	return level_manager.points >= points_to_win

func get_objective_text() -> String:
	return "Get {0} points".format([points_to_win])
