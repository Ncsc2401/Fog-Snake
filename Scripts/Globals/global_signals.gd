extends Node

## Emitted every x time amount (see GlobalSignals tick time)
signal Tick

## Total ticks
var ticks = 0;
## Seconds for each tick
var tick_time = 0.25;
## Time in seconds, resets every tick
var time = 0;

func _process(delta: float) -> void:
	# Tick emmision
	time += delta;
	if time > tick_time:
		Tick.emit();
		ticks += 1;
		time = 0;
