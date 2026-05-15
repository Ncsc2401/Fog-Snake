extends Node2D

@onready var fruit_fragments: GPUParticles2D = $FruitFragments
@onready var fruit_juice: GPUParticles2D = $FruitJuice

@export var on_ready : bool = false;

func _ready() -> void:
	if on_ready:
		emit()

func emit():
	fruit_fragments.emitting = true;
	fruit_juice.emitting = true;
	
	await fruit_fragments.finished
	await fruit_juice.finished
	
	queue_free();
