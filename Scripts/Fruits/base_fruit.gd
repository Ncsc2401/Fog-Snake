@abstract
extends Node2D

class_name BaseFruit

@export var fruit_resource : FruitResource;

## Amount of ticks needed to execute fruit_logic();
@export var fruit_tick_time : int = 1;

var tick : int;

var fruit_spawner : FruitSpawner
var tilemap_pos : Vector2i;
var level_manager : LevelManager;
var fruit_layer : TileMapLayer;

var was_eaten : bool = false;

func _ready() -> void:
	GlobalSignals.Tick.connect(on_tick);

func on_tick():
	tick += 1;
	if tick >= fruit_tick_time:
		on_fruit_tick();
		tick = 0;

## Moves relative to the fruit layer
func move_to(pos : Vector2i):
	if was_eaten:
		return;
		
	var previous_tilemap_pos = tilemap_pos;
	
	tilemap_pos = pos;
	
	var world_pos : Vector2 = fruit_layer.to_global(fruit_layer.map_to_local(pos));
	global_position = world_pos;
	
	if level_manager.board.has(previous_tilemap_pos) && level_manager.board[previous_tilemap_pos] == BoardData.FRUIT:
		level_manager.board[previous_tilemap_pos] = BoardData.EMPTY;
	
	level_manager.fruits.erase(previous_tilemap_pos);
	level_manager.fruits[pos] = self;
	level_manager.board[pos] = BoardData.FRUIT;

func delete_self():
	queue_free();

@abstract
func on_fruit_tick();

## Used to avoid the need of calling super to set was_eaten to true
func on_eat_call():
	on_eat()
	was_eaten = true;

@abstract
func on_eat();
