extends Node

## Emitted every x time amount (see GlobalSignals tick time)
signal Tick

## Total ticks
var ticks = 0;
## Seconds for each tick
var tick_time = 0.25;
## Time in seconds, resets every tick
var time = 0;

var tick_time_multiplier = 1;

func _process(delta: float) -> void:
	# Tick emmision
	time += delta;
	if time > tick_time * tick_time_multiplier:
		Tick.emit();
		ticks += 1;
		time = 0;
