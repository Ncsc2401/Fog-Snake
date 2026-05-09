@abstract
extends Node2D

class_name BaseEnemy

## How many ticks to enemy to act
@export var enemy_tick_time : int

## How many points are given when enemy dies
@export var enemy_points_on_death : int = 0;

## How many ticks before enemy tick  
@export var warning_window_time : int

@export var warning_layer: TileMapLayer;

var level_manager : LevelManager
var enemy_layer: TileMapLayer
var enemy_spawner : EnemySpawner

var board_pos : Vector2i;

var is_alive : bool = true;
var just_died : bool = false;

var tick : int = 0;

func _ready() -> void:
	await get_tree().process_frame
	
	level_manager.enemies.append(self);
	on_spawn()

func on_tick():
	# check if alive
	if !is_enemy_alive() and is_alive:
		just_died = true;
		is_alive = false;
	
	tick += 1;
	if tick + warning_window_time >= enemy_tick_time:
		on_enemy_warning_window()
	if tick >= enemy_tick_time:
		on_enemy_tick();
		tick = 0;

## Called every warning_tick_time ticks before enemy tick
@abstract
func on_enemy_warning_window()

## Called every enemy_tick_time ticks
@abstract
func on_enemy_tick();

## Called upon death
@abstract
func on_die();

## Called upon spawn
@abstract
func on_spawn();

## Checks if it is still alive
@abstract 
func is_enemy_alive();

## Make a warning
func warn_player(pos : Vector2i):
	if !is_alive:
		return
	
	warning_layer.set_cell(pos, 0, Vector2i(0, 0))

## Removes all warnings
func clear_warnings():
	warning_layer.clear()

## Moves relative to enemy layer
func move_to(pos : Vector2i):
	if !is_alive:
		return;
	
	board_pos = pos;
	
	var world_pos : Vector2 = enemy_layer.to_global(enemy_layer.map_to_local(board_pos));
	global_position = world_pos;

func delete_self():
	level_manager.enemies.erase(self);
	queue_free()

## Used to avoid the need of calling super to set is_alive and just died to false
func on_die_call():
	just_died = false;
	is_alive = false;
	on_die();
