extends BaseWinCondition

class_name KillsWinCondition

@export var kills_to_win : int = -1

func check_win() -> bool:
	return level_manager.kills >= kills_to_win;

func get_objective_text() -> String:
	return "Kill {0} enemies".format([kills_to_win])
