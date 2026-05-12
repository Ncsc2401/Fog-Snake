@abstract
extends Resource;

class_name BaseFindComponent

var brain_key_to_store : String;

var actor : Actor;
var is_initialized : bool = false;

func initialize(actor : Actor):
	self.actor = actor;
	set_brain_key_to_store()
	is_initialized = true;

@abstract
func set_brain_key_to_store()

@abstract
func can_do_action() -> bool;

@abstract
func search();
