extends BaseActorAction

class_name WarnActorAction

enum Operation {
	WARN,
	CLEAR,
	CLEAR_ALL
}

enum WarnPosition {
	FROM_MEMORY,
	CONSTANT,
}

@export var operation : Operation;

@export var warn_position : WarnPosition

## Used when warn_position == CONSTANT
@export var constant_warn_position : Vector2i

## Used when warn_position == FROM_MEMORY
@export var warn_position_key : String

## If true it can warn the position it already is on
@export var can_warn_self : bool

func can_do_action() -> bool:
	if operation == Operation.CLEAR_ALL:
		return true
	
	match warn_position:
		WarnPosition.FROM_MEMORY:
			if !actor.brain.has_brain_key(warn_position_key):
				return false
	
	var warning_position : Vector2i;
	match warn_position:
		WarnPosition.FROM_MEMORY:
			warning_position = actor.brain.get_from_brain_vector2i(warn_position_key);
		WarnPosition.CONSTANT:
			warning_position = constant_warn_position;
	
	if !can_warn_self:
		if warning_position == actor.board_position:
			return false

	return true;


func do_action():
	if operation == Operation.CLEAR_ALL:
		actor.warning_layer.clear()
		return;
	
	var warning_position : Vector2i
	
	match warn_position:
		WarnPosition.FROM_MEMORY:
			warning_position = actor.brain.get_from_brain_vector2i(warn_position_key);
		WarnPosition.CONSTANT:
			warning_position = constant_warn_position;
	
	match operation:
		Operation.WARN:
			actor.warning_layer.set_cell(warning_position, actor.warning_layer_source, actor.warning_layer_coordinate)
		Operation.CLEAR_ALL:
			actor.warning_layer.erase_cell(warning_position);
