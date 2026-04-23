extends Line2D

class_name MapLevelBridge

const NORMAL_BRIDGE_COLOR = Color(1, 1, 1);
const CHALLENGE_BRIDGE_COLOR = Color(1, 0, 0);
const BONUS_BRIDGE_COLOR = Color(1, 0.9568, 0);
const SPECIAL_BRIDGE_COLOR = Color(0, 0.0862, 1);
const LOCKED_BRIDGE_COLOR = Color(0, 0, 0);
const SECRET_BRIDGE_COLOR = Color(0.1, 0.1, 0.1)

@export_storage var to : MapLevelData;

func _ready() -> void:
	update_color();

func update_color():
	if to == null:
		return;
	
	if !to.get_saveable_data().unlocked:
		default_color = LOCKED_BRIDGE_COLOR;
		return;
	
	# Setting level bridge color
	match to.level_type:
		to.LevelType.NORMAL:
			default_color = NORMAL_BRIDGE_COLOR;
		to.LevelType.BONUS:
			default_color = BONUS_BRIDGE_COLOR;
		to.LevelType.CHALLENGE:
			default_color = CHALLENGE_BRIDGE_COLOR;
		to.LevelType.SPECIAL:
			default_color = SPECIAL_BRIDGE_COLOR;
		to.LevelType.SECRET:
			default_color = SECRET_BRIDGE_COLOR;
