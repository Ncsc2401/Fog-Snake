extends Node2D

signal ChunkDespawned

const flesh_chunk_sprites : Dictionary = {
	0: preload("uid://vpoh0s0p685x"),
	1 : preload("uid://bmweqqk0ok62x"),
	2 : preload("uid://dxk1inunohv4m"),
	3 : preload("uid://rkav3tcpoexf"),
	4 : preload("uid://40aqf8qhal3u"),
	5 : preload("uid://dqf4i7culeb1o")
}

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export_subgroup("Initial Velocity")
@export var velocity_min : float;
@export var velocity_max : float;

@export var acceleration : float = -30;

var direction : Vector2;
var velocity : float;

func despawn():
	ChunkDespawned.emit();
	queue_free()

func _ready() -> void:
	var flesh_chunk_int = randi_range(0, 5);
	sprite_2d.texture = flesh_chunk_sprites[flesh_chunk_int];
	
	velocity = randf_range(velocity_min, velocity_max);
	
	direction = Vector2.from_angle(randf_range(0, 2*PI));

func _process(delta: float) -> void:
	global_position += direction * velocity * delta;
	velocity = clampf(velocity + acceleration * delta, 0, INF);

func start() -> void:
	animation_player.play("animation");
