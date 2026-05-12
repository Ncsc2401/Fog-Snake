@abstract
extends Resource

class_name BaseChooseComponent

var brain_key_to_store : StringName

var actor : Actor;
var is_initialized : bool = false;

func initialize(actor : Actor):
	self.actor = actor;
	set_brain_key_to_store();
	is_initialized = true;

@abstract
func set_brain_key_to_store();

@abstract 
func can_do_action() -> bool;

@abstract
func choose();
