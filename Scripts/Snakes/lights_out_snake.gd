extends NormalSnake

class_name LightsOutSnake

@onready var aura: PointLight2D = $LightPivot/Aura
@onready var flashlight: PointLight2D = $LightPivot/Flashlight
@onready var light_pivot: Node2D = $LightPivot

func _ready() -> void:
	super();
	
	await get_tree().process_frame
	
	light_pivot.global_position = snake_layer.to_global(snake_layer.map_to_local(head.position))
	light_pivot.global_rotation = direction_to_angle[direction]

func move():
	super();
	light_pivot.global_position = snake_layer.to_global(snake_layer.map_to_local(head.position))
	light_pivot.global_rotation = direction_to_angle[direction]

func die():
	light_off()
	is_dead = true;
	GameOver.emit();

func light_off():
	aura.hide();
	flashlight.hide();

func light_on():
	aura.show();
	flashlight.show()
