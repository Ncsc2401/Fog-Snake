extends Node2D

const ENEMY_FLESH_CHUNK = preload("uid://bb0f6lpa63n2m")

@onready var blood: GPUParticles2D = $Blood

@export var flesh_chunk_amount : int = 5

@export var on_ready : bool = false;

func _ready() -> void:
	if on_ready:
		emit();

func emit():
	var enemy_flesh_chunks = []
	for i in range(flesh_chunk_amount):
		var enemy_flesh_chunk = ENEMY_FLESH_CHUNK.instantiate();
		enemy_flesh_chunks.append(enemy_flesh_chunk);
		add_child(enemy_flesh_chunk);
	
	blood.emitting = true;
	for enemy_flesh_chunk in enemy_flesh_chunks:
		enemy_flesh_chunk.start();
	
	for enemy_flesh_chunk in enemy_flesh_chunks:
		await enemy_flesh_chunk.ChunkDespawned
	
	await blood.finished;
	
	queue_free();
