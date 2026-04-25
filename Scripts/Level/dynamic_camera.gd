extends Camera2D

class_name DynamicCamera

@export var snake : Snake;

@onready var reference_tilemap: TileMapLayer = $ReferenceTilemap

func _ready() -> void:
	GlobalSignals.Tick.connect(on_tick);

func on_tick():
	var local = reference_tilemap.map_to_local(snake.head.position);
	global_position = reference_tilemap.to_global(local);
