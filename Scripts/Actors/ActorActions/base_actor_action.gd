@abstract
extends Resource

class_name BaseActorAction

var is_initialized : bool = false;
var actor : Actor;

@export var enabled : bool = true;

## If true, the action executes only once
@export var one_time : bool = false;

@export var action_tick : int;

## Lower priority means it happens first if there are multiple actions in the same tick
## If 2 ore more actions gave the same priority, them the order is random
@export var action_priority : int;

func initialize(actor : Actor):
	is_initialized = true;
	self.actor = actor;

@abstract
func can_do_action() -> bool;

@abstract
func do_action();
