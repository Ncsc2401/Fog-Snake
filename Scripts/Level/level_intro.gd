extends Node2D

@onready var level_intro_ui: Control = $CanvasLayer/LevelIntroUi

@onready var title: Label = $CanvasLayer/LevelIntroUi/LevelInfo/MarginContainer/VBoxContainer/Title
@onready var objective: Label = $CanvasLayer/LevelIntroUi/LevelInfo/MarginContainer/VBoxContainer/Objective

func _ready() -> void:
	await get_tree().process_frame
	
	GameState.pause_game()
	set_display()
	GameState.game_state = GameState.LEVEL_INTRO

func set_display():
	title.text = SaveManager.current_level.level_name;
	objective.text = SaveManager.current_level.objecive;

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if GameState.game_state == GameState.LEVEL_INTRO:
			start_level()

func start_level():
	GameState.game_state = GameState.RUNNING;
	GameState.unpause_game()
	level_intro_ui.hide();
