extends Node2D

## First level it will be looking at
@export var first_focused_level : MapLevel

@onready var map_level_anchor: Control = $CanvasLayer/MapLevelAnchor
@onready var camera_2d: Camera2D = $Camera2D

@onready var levels: Node2D = $Levels
@onready var bridges: Node2D = $Bridges

@onready var max_points_label: Label = $CanvasLayer/LevelDisplayData/MarginContainer/HBoxContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/ScrollContainer/VBoxContainer/MaxPoints
@onready var max_size_label: Label = $CanvasLayer/LevelDisplayData/MarginContainer/HBoxContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/ScrollContainer/VBoxContainer/MaxSize
@onready var least_time_label: Label = $CanvasLayer/LevelDisplayData/MarginContainer/HBoxContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/ScrollContainer/VBoxContainer/LeastTime

@onready var level_name_label: Label = $CanvasLayer/LevelDisplayData/MarginContainer/HBoxContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/LevelName
@onready var objective_label: Label = $CanvasLayer/LevelDisplayData/MarginContainer/HBoxContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/Objective

## Current level at focus
var focused_level : MapLevel;

var grid_pos : Vector2i;
var level_grid : Dictionary[Vector2i, MapLevel];

func _ready() -> void:
	await get_tree().process_frame
	setup_level_grid()
	
	if SaveManager.last_focused_level_pos == null:
		look_at_level(first_focused_level);
	else:
		look_at_pos(SaveManager.last_focused_level_pos);

func _input(event: InputEvent) -> void:
	handle_input(event)

func handle_input(event : InputEvent):
	var next_pos : Vector2i;
	var was_event_pressed : bool = false;
	if event.is_action_pressed("Down"):
		next_pos = grid_pos + Vector2i(0, 1);
		was_event_pressed = true;
	
	elif event.is_action_pressed("Left"):
		next_pos = grid_pos + Vector2i(-1, 0);
		was_event_pressed = true;
	
	elif event.is_action_pressed("Up"):
		next_pos = grid_pos + Vector2i(0, -1);
		was_event_pressed = true;
	
	elif event.is_action_pressed("Right"):
		next_pos = grid_pos + Vector2i(1, 0);
		was_event_pressed = true;
	
	elif event.is_action_pressed("Menu"):
		SceneManager.change_scene_to_main_menu()
	
	elif event.is_action_pressed("Select"):
		play_focused_level();
	
	if !was_event_pressed:
		return

	if level_grid.has(next_pos):
		if level_grid[next_pos].level_data.get_saveable_data().unlocked:
			look_at_level(level_grid[next_pos]);

func setup_level_grid():
	for level in levels.get_children():
		level_grid[level.level_data.pos] = level;

func update_displayed_data():
	var saved_data = focused_level.level_data.get_saveable_data();
	
	var max_points = saved_data.max_points;
	var max_size = saved_data.max_size;
	var least_time = saved_data.least_time
	
	var max_points_text = "Max Points = {0}".format([max_points]) if max_points != -1 else "No data :("
	var least_time_text = "Least Time = {0}".format([least_time]) if least_time != -1 else "No data :("
	var max_size_text = "Max Size = {0}".format([max_size]) if max_size != -1 else "No data :("
	
	max_points_label.text = max_points_text
	max_size_label.text = max_size_text
	least_time_label.text = least_time_text
	
	level_name_label.text = focused_level.level_data.level_name
	objective_label.text = focused_level.level_data.objecive

func get_level_from_data(data : MapLevelData):
	var level : MapLevel = levels.get_node(data.level_name);
	
	return level;

func look_at_level(level : MapLevel):
	# Distance from anchor to the center of screen
	var offset_from_center = get_viewport_rect().size / 2 - map_level_anchor.position
	grid_pos = level.level_data.pos;
	
	SaveManager.last_focused_level_pos = level.level_data.pos;
	
	camera_2d.global_position = level.global_position + offset_from_center;
	focused_level = level;
	
	update_displayed_data()

func look_at_pos(pos : Vector2i):
	# Distance from anchor to the center of screen
	var offset_from_center = get_viewport_rect().size / 2 - map_level_anchor.position
	grid_pos = pos;
	
	SaveManager.last_focused_level_pos = pos;
	
	camera_2d.global_position = level_grid[pos].global_position + offset_from_center;
	focused_level = level_grid[pos];
	
	update_displayed_data()

func _on_play_button_pressed() -> void:
	play_focused_level();

func play_focused_level():
	SaveManager.current_level = focused_level.level_data;
	SceneManager.change_scene_to_level(focused_level.level_data.level_scene);
