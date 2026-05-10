extends BaseFruitEatComponent

class_name ChangeGameSpeedEatComponent

enum ActionType {
	SET,
	SUM,
	MULTIPLY
}

@export var action_type : ActionType
@export var value : float;

func on_eat():
	var game_speed = GlobalSignals.tick_time
	
	var new_game_speed : float;
	
	match action_type:
		ActionType.SET:
			new_game_speed = value;
		ActionType.SUM:
			new_game_speed = game_speed + value;
		ActionType.MULTIPLY:
			new_game_speed = game_speed * value;
	
	fruit.level_manager.change_game_speed(new_game_speed);
