extends Camera2D

class_name DynamicCamera

@export var snake : Snake;

@onready var reference_tilemap: TileMapLayer = $ReferenceTilemap

var snake_previous_pos : Vector2;
var snake_pos : Vector2;

var time_since_last_tick : float;

func _ready() -> void:
	await get_tree().process_frame
	global_position = get_snake_head_global_pos()
	snake_pos = get_snake_head_global_pos();
	snake_previous_pos = snake_pos
	reset_smoothing()
	GlobalSignals.Tick.connect(on_tick);

func on_tick():
	await get_tree().process_frame
	time_since_last_tick = 0;
	snake_previous_pos = snake_pos;
	snake_pos = get_snake_head_global_pos();

func _process(delta: float) -> void:
	time_since_last_tick += delta;
	interpolate_movement()

func interpolate_movement():
	var t : float = clampf(time_since_last_tick / GlobalSignals.tick_time, 0, 1)
	
	var interpolated_pos = snake_previous_pos.lerp(snake_pos, t)
	
	global_position = interpolated_pos

func get_snake_head_global_pos() -> Vector2:
	return reference_tilemap.to_global(reference_tilemap.map_to_local(snake.head.pos));
