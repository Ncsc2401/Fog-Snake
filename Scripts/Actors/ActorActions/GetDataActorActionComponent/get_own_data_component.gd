extends BaseGetDataComponent

class_name GetOwnDataComponent

enum DataField {
	BOARD_POSITION,
}

@export var data_field : DataField

func set_brain_key_to_store():
	brain_key_to_store = custom_key_value

func can_do_action() -> bool:
	return true;

func get_data():
	match data_field:
		DataField.BOARD_POSITION:
			return actor.board_position;
