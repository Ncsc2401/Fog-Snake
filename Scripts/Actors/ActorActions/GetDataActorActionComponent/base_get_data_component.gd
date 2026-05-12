@abstract
extends Resource

class_name BaseGetDataComponent

var actor : Actor
var is_initialized : bool = false

var brain_key_to_store : String;

## Uses this key to save the data
## If this is null or empty, then it uses the default path (recommended)
@export var custom_key_value : String

func initialize(actor : Actor):
	self.actor = actor;
	set_brain_key_to_store()
	is_initialized = true;

@abstract
func set_brain_key_to_store()

@abstract
func can_do_action() -> bool;

@abstract
func get_data()

func has_custom_key_value():
	return custom_key_value != null and !custom_key_value.is_empty()
