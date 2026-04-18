extends Control

func _on_unpause_button_pressed() -> void:
	GameState.unpause_game();
	GameState.game_state = GameState.RUNNING
	hide();

func _on_settings_button_pressed() -> void:
	pass # Replace with function body.

func _on_return_to_menu_button_pressed() -> void:
	SceneManager.change_scene_to_main_menu();
	
