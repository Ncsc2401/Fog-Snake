@abstract
extends Resource

class_name BaseSetMemoryComponent

var actor : Actor;
var is_initialized : bool = false;

func initialize(actor : Actor):
	self.actor = actor;
	is_initialized = true;

@abstract
func can_do_action() -> bool

@abstract
func set_memory(brain_key : String);
