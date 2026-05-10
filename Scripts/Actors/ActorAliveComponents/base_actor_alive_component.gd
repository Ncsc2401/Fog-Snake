@abstract
extends Resource

class_name BaseActorAliveComponent

var actor : Actor;
var is_initialized : bool = false;

func initialize(actor : Actor):
	is_initialized = true;
	self.actor = actor;

@abstract
func is_alive();
