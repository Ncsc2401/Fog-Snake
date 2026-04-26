extends Node2D

@onready var map_level_anchor: Control = $CanvasLayer/MapLevelAnchor
@onready var camera_2d: Camera2D = $Camera2D

@onready var levels: Node2D = $Levels
@onready var bridges: Node2D = $Bridges

@onready var won_label: Label = $CanvasLayer/LevelDisplayData/MarginContainer/HBoxContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/ScrollContainer/VBoxContainer/Won
@onready var max_points_label: Label = $CanvasLayer/LevelDisplayData/MarginContainer/HBoxContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/ScrollContainer/VBoxContainer/MaxPoints
@onready var max_size_label: Label = $CanvasLayer/LevelDisplayData/MarginContainer/HBoxContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/ScrollContainer/VBoxContainer/MaxSize
@onready var least_time_label: Label = $CanvasLayer/LevelDisplayData/MarginContainer/HBoxContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/ScrollContainer/VBoxContainer/LeastTime
@onready var tries_to_win_label: Label = $CanvasLayer/LevelDisplayData/MarginContainer/HBoxContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/ScrollContainer/VBoxContainer/TriesToWin
@onready var total_tries_label: Label = $CanvasLayer/LevelDisplayData/MarginContainer/HBoxContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/ScrollContainer/VBoxContainer/TotalTries

@onready var level_name_label: Label = $CanvasLayer/LevelDisplayData/MarginContainer/HBoxContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/LevelName
@onready var objective_label: Label = $CanvasLayer/LevelDisplayData/MarginContainer/HBoxContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/Objective

@onready var background: ColorRect = $BackgroundLayer/Control/Background

## Current level at focus
var focused_level : MapLevel;

var grid_pos : Vector2i;
var level_grid : Dictionary[Vector2i, MapLevel];

func _ready() -> void:
	await get_tree().process_frame
	
	setup_level_grid()
	
	look_at_pos(SaveManager.last_focused_level_pos);
	camera_2d.reset_smoothing()

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
		await play_focused_level();
	
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
	
	var won = saved_data.won;
	var max_points = saved_data.max_points;
	var max_size = saved_data.max_size;
	var least_time = saved_data.least_time
	var total_tries = saved_data.total_tries;
	var tries_to_win = saved_data.tries_to_win
	
	var won_text = "Won = Yes" if won else "Won = No"
	var max_points_text = "Max Points = {0}".format([max_points]) if max_points != -1 else "No data :("
	var least_time_text = "Least Time = {0}".format([least_time]) if least_time != -1 else "No data :("
	var max_size_text = "Max Size = {0}".format([max_size]) if max_size != -1 else "No data :("
	var total_tries_text = "Total Tries = {0}".format([total_tries])
	var tries_to_win_text = "Tries to Win = {0}".format([tries_to_win]) if tries_to_win != -1 else "No data :("
	
	won_label.text = won_text
	max_points_label.text = max_points_text
	max_size_label.text = max_size_text
	least_time_label.text = least_time_text
	total_tries_label.text = total_tries_text
	tries_to_win_label.text = tries_to_win_text
	
	level_name_label.text = focused_level.level_data.level_name
	objective_label.text = focused_level.level_data.objective

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
	await play_focused_level();

func play_focused_level():
	SaveManager.current_level = focused_level.level_data;
	SceneManager.change_scene_to_level(focused_level.level_data.level_scene);

func unlock_all_cheat_code():
	SaveManager.unloack_all()
	for bridge in bridges.get_children():
		bridge.update_color();

func make_background_white_cheat_code():
	if background.color == Color.WHITE:
		background.color = Color.BLACK
	elif background.color == Color.BLACK:
		background.color = Color.WHITE

func increase_game_speed_cheat_code():
	print("Increase")
	GlobalSignals.tick_time_multiplier *= 0.8;

func decrease_game_speed_cheat_code():
	print("Decrease")
	GlobalSignals.tick_time_multiplier *= 1.25;

func reset_game_speed_to_normal_cheat_code():
	print("Default")
	GlobalSignals.tick_time_multiplier = 1;
