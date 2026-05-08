extends Control

# Variables usefull for multi levels
var reload_current_scene : bool = true;
var play_again_scene : PackedScene

func _ready() -> void:
	hide();

func _input(event: InputEvent) -> void:
	if visible:
		if event.is_action_pressed("Menu"):
			return_to_map()
		
		elif event.is_action_pressed("Select"):
			play_again()

## Display itself and update game state, called when snake.GameOver is emitted
func activate():
	show();
	GameState.pause_game();
	GameState.game_state = GameState.GAMEOVER

func play_again():
	GameState.game_state = GameState.RUNNING
	if !reload_current_scene and play_again_scene != null:
		SceneManager.change_scene_with_ps(play_again_scene);
	else:
		SceneManager.reload()

func return_to_map():
	SceneManager.change_scene_to_map();

func _on_play_again_button_pressed() -> void:
	play_again()

func _on_return_to_map_button_pressed() -> void:
	return_to_map()
