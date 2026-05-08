@abstract
extends BaseSnakeComponent

class_name BaseSnakeMiscComponent;

func initialize(snake : BaseSnake):
	super(snake)
	on_initialize();

## Called once when initiallized
@abstract
func on_initialize();

## Called every time snake moves
@abstract
func on_move(direction : BaseSnake.Directions);

## Called every frame
@abstract
func on_process(delta : float);

## Called when snake dies
@abstract
func on_death();

## Called when snake grows
@abstract
func on_grow();

## Called when snake eats
@abstract
func on_eat(fruit_resource : FruitResource);
