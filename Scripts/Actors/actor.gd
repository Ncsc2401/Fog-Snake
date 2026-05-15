@abstract
extends Node2D

class_name Actor;

var level_manager : LevelManager;

## A node that stores all actor action nodes
@export var actor_action_nodes_parent : Node

@export var max_ticks : int = 0;

@export var alive_component : BaseActorAliveComponent

@export_subgroup("Debug", "debug_")
@export var debug_print_failed_actions : bool = false
@export var debug_print_brain_data_every_tick : bool = false;
@export var debug_print_current_tick : bool = false;

var l_alive_component : BaseActorAliveComponent;

var reference_tilemap : TileMapLayer;

## The spawner that spawned the actor
var actor_spawner : BaseSpawner;

## Stores values shared between actions
var brain : ActorBrain;

## Position in the board;
var board_position : Vector2i;

## Start at -1 so the first tick_logic() is tick 0
var current_tick : int = -1;

var was_new_tick_requested : bool = false;
var new_tick_requested : int = -1;

var actions : Array[BaseActorAction] = [];

func initialize(initial_board_position : Vector2i, initial_global_position : Vector2, level_manager : LevelManager, reference_tilemap : TileMapLayer, actor_spawner : BaseSpawner):
	board_position = initial_board_position
	global_position = initial_global_position
	self.level_manager = level_manager
	self.reference_tilemap = reference_tilemap;
	self.actor_spawner = actor_spawner
	
	brain = ActorBrain.new();
	
	current_tick = -1;
	initialize_actions();
	
	l_alive_component = alive_component.duplicate();
	l_alive_component.initialize(self);

func is_actor_alive() -> bool:
	return l_alive_component.is_alive()

func on_tick():
	current_tick += 1;
	apply_tick_change()
	current_tick %= max_ticks + 1
	process_actions();

func initialize_actions():
	if actor_action_nodes_parent == null:
		push_warning("No action nodes parent")
		return
	
	for node in actor_action_nodes_parent.get_children():
		if node is not ActorActionNode:
			continue;
		
		if node.actor_action == null:
			continue;
		
		var actor_action : BaseActorAction = node.actor_action.duplicate() 
		
		actions.append(actor_action);
		actor_action.initialize(self);

func process_actions():
	var to_do_actions : Array[BaseActorAction]
	for action in actions:
		if action.action_tick != current_tick:
			continue
		
		if action.is_initialized == false:
			continue;
		
		if action.enabled == false:
			continue;
		
		to_do_actions.append(action);
	
	if debug_print_current_tick:
		print("Tick - %d" % current_tick);
	
	to_do_actions.sort_custom(func(a : BaseActorAction, b : BaseActorAction): return a.action_priority < b.action_priority)
	
	for action in to_do_actions:
		if !action.can_do_action():
			if debug_print_failed_actions:
				print("Failed {0} {1}".format([action.action_tick, action.action_priority]))
			continue
		
		action.do_action();
		
		if action.one_time:
			action.enabled = false;
	
	if debug_print_brain_data_every_tick:
		print("Brain: {0} \n".format([brain.saved_data]));

func request_tick_change(new_tick : int):
	new_tick_requested = new_tick;
	was_new_tick_requested = true;

func apply_tick_change():
	if was_new_tick_requested == false:
		return;
	
	was_new_tick_requested = false;
	current_tick = new_tick_requested;
