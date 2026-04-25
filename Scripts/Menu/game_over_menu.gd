extends Control

# Variables usefull for multi levels
var reload_current_scene : bool = true;
var play_again_scene : PackedScene

## Display itself and update game state, called when snake.GameOver is emitted
func activate():
	show();
	GameState.pause_game();
	GameState.game_state = GameState.GAMEOVER

func _on_play_again_button_pressed() -> void:
	GameState.game_state = GameState.RUNNING
	if !reload_current_scene and play_again_scene != null:
		SceneManager.change_scene_with_ps(play_again_scene);
	else:
		SceneManager.reload()

func _on_return_to_map_button_pressed() -> void:
	SceneManager.change_scene_to_map();
