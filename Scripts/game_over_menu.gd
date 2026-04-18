extends Control

@export var snake : Snake

func _ready() -> void:
	snake.GameOver.connect(activate);

## Display itself and update game state, called when snake.GameOver is emitted
func activate():
	show();
	GameState.pause_game();
	GameState.game_state = GameState.GAMEOVER

func _on_play_again_button_pressed() -> void:
	GameState.game_state = GameState.RUNNING
	SceneManager.reload()

func _on_return_to_menu_button_pressed() -> void:
	SceneManager.change_scene_to_main_menu();
