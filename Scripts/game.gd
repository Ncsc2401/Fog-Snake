extends Node2D

@onready var in_game_menu: Control = $CanvasLayer/InGameMenu

func _input(event: InputEvent) -> void:
	## Pauses when "Menu" button is pressed (default -> esc)
	if event.is_action_pressed("Menu"):
		if GameState.game_state == GameState.RUNNING:
			GameState.pause_game();
			in_game_menu.show();
		
