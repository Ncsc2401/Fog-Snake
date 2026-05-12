extends Resource

class_name ActorBrain

# REALLY IMPORTANT BRAIN KEYS
## Possible board movements, should be an Array[Vector2i]
const POSSIBLE_BOARD_MOVEMENTS = "Possible Board Movements"

## Next place it wants to go in the board, should be a Vector2i
const NEXT_BOARD_MOVEMENT = "Next Board Movement";

## Next place it wants to go globally, should be a Vector2
const NEXT_GLOBAL_MOVEMENT = "Next Global Movement"
# END OF IMPORTANT BRAIN KEYS

var saved_data : Dictionary[String, Variant];

## Returns the stored value for the key or null if there is nothing. 
## If possible, use the function with type safety, like get_from_brain_vector2(key)
func get_from_brain(key : String):
	var normalized_key = get_normalized_key(key);
	
	if !has_brain_key(key):
		return null;
	
	return saved_data[normalized_key];

func get_from_brain_vector2(key : String) -> Vector2:
	var result = get_from_brain(key);
	
	if result is Vector2i:
		return Vector2(result);
	
	if result == null or result is not Vector2:
		push_error("The result type don't match the function call");
		return Vector2.ZERO
	
	return result;

func get_from_brain_vector2i(key : String) -> Vector2i:
	var result = get_from_brain(key);
	
	if result is Vector2:
		return Vector2i(result);
	
	if result == null or result is not Vector2i:
		push_error("The result type don't match the function call");
		return Vector2i.ZERO
	
	return result;

func get_from_brain_int(key : String) -> int:
	var result = get_from_brain(key);
	
	if result is float:
		return int(result)
	
	if result == null or result is not int:
		push_error("The result type don't match the function call");
		return -1;
	
	return result;

func get_from_brain_float(key : String) -> float:
	var result = get_from_brain(key);
	
	if result is int:
		return float(result)
	
	if result == null or result is not float:
		push_error("The result type don't match the function call");
		return -1
	
	return result;

func get_from_brain_string(key : String) -> String:
	var result = get_from_brain(key);
	
	if result == null or result is not String:
		push_error("The result type don't match the function call");
		return ""
	
	return result;

func get_from_brain_array(key : String) -> Array:
	var result = get_from_brain(key);
	
	if result == null or result is not Array:
		push_error("The result type don't match the function call");
		return [];
	
	return result;

func get_from_brain_bool(key : String) -> bool:
	var result = get_from_brain(key);
	
	if result == null or result is not bool:
		push_error("The result type don't match the function call");
		return false;
	
	return result;

## Saves a value to the given key
func save_in_brain(key : String, value):
	var normalized_key = get_normalized_key(key);
	
	saved_data[normalized_key] = value;

## Returns if key has any values
func has_brain_key(key : String):
	var normalized_key = get_normalized_key(key);
	
	return saved_data.has(normalized_key);

## Returns a normalized string in the form "brainkey"
static func get_normalized_key(key : String) -> String:
	return key.to_lower().replace(" ", "").replace("_", "");

## Erase key from saved data
func forget_key(key : String):
	var normalized_key = get_normalized_key(key);
	
	if saved_data.has(normalized_key):
		saved_data.erase(normalized_key);

## Erases everything in the saved data
func clear_brain():
	saved_data.clear();
	
