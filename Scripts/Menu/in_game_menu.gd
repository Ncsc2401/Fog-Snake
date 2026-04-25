extends Control

@onready var settings_ui: Control = $SettingsUI
@onready var level_objective: Label = $MarginContainer/VBoxContainer/LevelObjective

var is_settings_open : bool = false;

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Menu"):
		if GameState.game_state == GameState.RUNNING:
			activate()
		elif GameState.game_state == GameState.PAUSED && visible:
			deactivate()

func activate():
	show();
	GameState.pause_game();
	level_objective.text = SaveManager.current_level.objective;

func deactivate():
	hide();
	GameState.unpause_game();
	GameState.game_state = GameState.RUNNING;

func _on_resume_button_pressed() -> void:
	GameState.unpause_game();
	GameState.game_state = GameState.RUNNING
	hide();

func _on_settings_button_pressed() -> void:
	if is_settings_open:
		close_settings();
	else:
		open_settings();

func _on_return_to_map_pressed() -> void:
	SceneManager.change_scene_to_map();

func open_settings():
	is_settings_open = true;
	settings_ui.activate();

func close_settings():
	is_settings_open = false;
	settings_ui.hide();
