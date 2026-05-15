extends BaseActorAction

class_name WarnActorAction

const WARNING_LAYER = preload("uid://cedmegqdgql04")

enum Operation {
	WARN,
	CLEAR,
	CLEAR_ALL
}

enum WarnPosition {
	FROM_MEMORY,
	CONSTANT,
}

enum WarningType {
	RED_EXCLAMATION_MARK,
	GREEN_EXCLAMATION_MARK,
	RED_QUESTION_MARK,
	GREEN_QUESTION_MARK
}

@export var operation : Operation;

@export var warn_position : WarnPosition

@export var warning_type : WarningType

## If true it can warn the position it already is on
@export var can_warn_self : bool

@export_subgroup("Warn position constant")
## Used when warn_position == CONSTANT
@export var constant_warn_position : Vector2i

@export_subgroup("Warn position from memory")
## Used when warn_position == FROM_MEMORY
@export var warn_position_key : String

var warning_layer : TileMapLayer;

func initialize(actor : Actor):
	super(actor);
	
	if actor.has_node("WarningLayer"):
		warning_layer = actor.get_node("WarningLayer");
	else:
		warning_layer = WARNING_LAYER.instantiate();
		actor.add_child(warning_layer);

func can_do_action() -> bool:
	if warning_layer == null or !is_instance_valid(warning_layer):
		return false;
	
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
		warning_layer.clear()
		return;
	
	var warning_position : Vector2i
	
	match warn_position:
		WarnPosition.FROM_MEMORY:
			warning_position = actor.brain.get_from_brain_vector2i(warn_position_key);
		WarnPosition.CONSTANT:
			warning_position = constant_warn_position;
	
	match operation:
		Operation.WARN:
			warning_layer.set_cell(warning_position, 0, get_warning_layer_coordinate())
		Operation.CLEAR_ALL:
			warning_layer.erase_cell(warning_position);

func get_warning_layer_coordinate():
	match warning_type:
		WarningType.RED_EXCLAMATION_MARK:
			return Vector2i(0, 0);
		WarningType.GREEN_EXCLAMATION_MARK:
			return Vector2i(1, 0);
		WarningType.RED_QUESTION_MARK:
			return Vector2i(0, 1);
		WarningType.GREEN_QUESTION_MARK:
			return Vector2i(1, 1);
