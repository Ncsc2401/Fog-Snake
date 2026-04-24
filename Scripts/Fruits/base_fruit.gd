@abstract
extends Node2D

class_name BaseFruit

@export var fruit_resource : FruitResource;

## Amount of ticks needed to execute fruit_logic();
@export var fruit_tick_time : int = 1;

var tick : int;

var fruit_spawner : FruitSpawner
var pos : Vector2i;
var level_manager : LevelManager;
var fruit_layer : TileMapLayer;

var was_eaten : bool = false;

func _ready() -> void:
	await get_tree().process_frame
	level_manager.fruits.append(self);

func on_tick():
	tick += 1;
	if tick >= fruit_tick_time:
		on_fruit_tick();
		tick = 0;

## Moves relative to the fruit layer
func move_to(new_pos : Vector2i):
	if was_eaten:
		return;
	
	pos = new_pos;
	
	var world_pos : Vector2 = fruit_layer.to_global(fruit_layer.map_to_local(pos));
	global_position = world_pos;

func delete_self():
	level_manager.fruits.erase(self)
	queue_free();

@abstract
func on_fruit_tick();

## Used to avoid the need of calling super to set was_eaten to true
func on_eat_call():
	on_eat()
	was_eaten = true;

@abstract
func on_eat();
