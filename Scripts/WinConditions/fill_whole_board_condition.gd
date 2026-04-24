extends BaseWinCondition

class_name FillWholeBoardWinCondition

func check_win() -> bool:
	return level_manager.get_empty_spaces().is_empty();

func get_objective_text() -> String:
	return "Fill whole board";
