extends BaseMathComponent

class_name VectorMathComponent

enum OperationType {
	SUM,
	SUBTRACTION,
	DOT,
	CROSS,
	IS_GREATER_THAN,
	IS_GREATER_OR_EQUAL,
	IS_SMALLER_THAN,
	IS_SMALLER_OR_EQUAL,
	IS_EQUAL,
	IS_DIFFERENT,
	MAX,
	MIN
}

enum RoundingMethod {
	NONE,
	CEIL,
	FLOOR,
	ROUND,
	TRUNC
}

@export var operation_type : OperationType
@export var rounding_method : RoundingMethod

func can_do_action(value_a, value_b) -> bool:
	if value_a is not Vector2 and value_a is not Vector2i:
		return false
	
	if value_b is not Vector2 and value_b is not Vector2i:
		return false
	
	return true

func get_result(value_a, value_b):
	value_a = Vector2(value_a)
	value_b = Vector2(value_b)
	var result = calculate(value_a, value_b);
	
	if result is bool:
		return result;
	
	var rounded_result = round_value(result)
	
	return rounded_result

func calculate(value_a : Vector2, value_b : Vector2):
	match operation_type:
		OperationType.SUM:
			return value_a + value_b
		OperationType.SUBTRACTION:
			return value_a - value_b
		OperationType.DOT:
			return value_a.dot(value_b)
		OperationType.CROSS:
			return value_a.cross(value_b)
		OperationType.IS_GREATER_THAN:
			return value_a > value_b
		OperationType.IS_GREATER_OR_EQUAL:
			return value_a >= value_b
		OperationType.IS_SMALLER_THAN:
			return value_a < value_b
		OperationType.IS_SMALLER_OR_EQUAL:
			return value_a <= value_b
		OperationType.IS_EQUAL:
			return value_a == value_b
		OperationType.IS_DIFFERENT:
			return value_a != value_b
		OperationType.MAX:
			return value_a.max(value_b)
		OperationType.MIN:
			return value_a.min(value_b)
		_:
			return 0;

func round_value(value : Vector2):
	match rounding_method:
		RoundingMethod.NONE:
			return value
		RoundingMethod.CEIL:
			value.ceil()
			return value
		RoundingMethod.FLOOR:
			value.floor()
			return value
		RoundingMethod.ROUND:
			value.round()
			return value
		RoundingMethod.TRUNC:
			return Vector2i(value);
	
	return Vector2i.ZERO
