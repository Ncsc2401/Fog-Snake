@abstract
extends Resource

class_name BaseWinCondition

var level_manager : LevelManager

@abstract
func check_win() -> bool

@abstract
func get_objective_text() -> String
