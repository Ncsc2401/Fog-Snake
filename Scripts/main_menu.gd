extends Control

func _on_play_button_pressed() -> void:
	SceneManager.change_scene_to_game();

func _on_settings_button_pressed() -> void:
	pass # Replace with function body.

func _on_credits_button_pressed() -> void:
	pass # Replace with function body.

func _on_quit_button_pressed() -> void:
	SceneManager.close_game()
