extends BaseSnakeMiscComponent

class_name LightSystemComponent

const LIGHT_SYSTEM = preload("uid://dcwcghgdqid4o")

var flashlight : Node2D
var aura : Node2D
var light_pivot : Node2D

func on_initialize():
	var light_system = LIGHT_SYSTEM.instantiate();
	
	snake.get_tree().current_scene.add_child(light_system);
	
	light_pivot = light_system.get_node("LightPivot")
	
	aura = light_pivot.get_node("Aura");
	flashlight = light_pivot.get_node("Flashlight");
	
	update_light_pos()
	
func on_move(direction : BaseSnake.Directions):	
	update_light_pos()

func on_process(delta : float):
	pass

func on_death():
	aura.hide();
	flashlight.hide();

func on_eat(fruit_resource : FruitResource):
	pass

func on_grow():
	pass

func update_light_pos():
	light_pivot.global_position = snake.snake_layer_to_global_pos(snake.head.pos);
	light_pivot.global_rotation = snake.direction_to_angle[snake.direction]
	
