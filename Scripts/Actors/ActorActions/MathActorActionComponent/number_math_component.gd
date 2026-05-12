extends BaseMathComponent

class_name NumberMathComponent

enum OperationType {
	SUM,
	SUBTRACTION,
	MULTIPLY,
	DIVIDE,
	POWER,
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
	if value_a is not float and value_a is not int:
		return false
	
	if value_b is not float and value_b is not int:
		return false
	
	return can_do_operation(value_a, value_b);
		

func get_result(value_a, value_b):
	value_a = float(value_a);
	value_b = float(value_b);
	
	var result = calculate(value_a, value_b);
	var rounded_result = round_value(result)
	
	return rounded_result

func calculate(value_a : float, value_b : float):
	match operation_type:
		OperationType.SUM:
			return value_a + value_b
		OperationType.SUBTRACTION:
			return value_a - value_b
		OperationType.MULTIPLY:
			return value_a * value_b
		OperationType.DIVIDE:
			return value_a / value_b
		OperationType.POWER:
			return pow(value_a, value_b)
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
			return maxf(value_a, value_b);
		OperationType.MIN:
			return minf(value_a, value_b);
		_:
			return 0;

func round_value(value):
	match RoundingMethod:
		RoundingMethod.NONE:
			return value
		RoundingMethod.CEIL:
			return ceil(value)
		RoundingMethod.FLOOR:
			return floor(value)
		RoundingMethod.ROUND:
			return round(value)
		RoundingMethod.TRUNC:
			return int(value);

func can_do_operation(value_a : float, value_b : float) -> bool:
	match operation_type:
		OperationType.SUM:
			return true;
		OperationType.SUBTRACTION:
			return true;
		OperationType.MULTIPLY:
			return true;
		OperationType.DIVIDE:
			return value_b != 0;
		OperationType.POWER:
			## Too much work to make a true check
			return value_a >= 0
		OperationType.IS_GREATER_THAN:
			return true
		OperationType.IS_GREATER_OR_EQUAL:
			return true
		OperationType.IS_SMALLER_THAN:
			return true
		OperationType.IS_SMALLER_OR_EQUAL:
			return true
		OperationType.IS_EQUAL:
			return true
		OperationType.MAX:
			return true
		OperationType.MIN:
			return true
		_:
			return false;
