extends Resource

class_name ActorBrain

# REALLY IMPORTANT BRAIN KEYS
## Possible board movements, should be an Array[Vector2i]
const POSSIBLE_BOARD_MOVEMENTS = "Possible Board Movements"

## Next place it wants to go in the board, should be a Vector2i
const NEXT_BOARD_MOVEMENT = "Next Board Movement";

## Next place it wants to go globally, should be a Vector2
const NEXT_GLOBAL_MOVEMENT = "Next Global Movement"

##  Last place it saw the snake, may be different to the real position, should be a Vector2
const SNAKE_POSITION_MEMORY = "Snake Position Memory";

var saved_data : Dictionary[String, Variant];

func get_from_brain(key : String):
	var normalized_key = get_normalized_key(key);
	
	if !has_brain_key(key):
		return null;
	
	return saved_data[normalized_key];

func save_in_brain(key : String, value):
	var normalized_key = get_normalized_key(key);
	
	saved_data[normalized_key] = value;

func has_brain_key(key : String):
	var normalized_key = get_normalized_key(key);
	
	return saved_data.has(normalized_key);

func get_normalized_key(key : String):
	return key.to_lower().replace(" ", "");
