extends BaseActorAliveComponent

class_name TimedActorAliveComponent

@export var time : float;

var time_ran_out : bool = false;

func initialize(actor : Actor):
	super(actor);
	
	if time > 0:
		actor.get_tree().create_timer(time).timeout.connect(timeout);
	else:
		time_ran_out = true;

func is_alive():
	return !time_ran_out;

func timeout():
	time_ran_out = true;
