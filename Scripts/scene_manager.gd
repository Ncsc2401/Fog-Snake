extends Node

const MAIN_MENU = "res://Scenes/main_menu.tscn"
const GAME = "res://Scenes/game.tscn"

## Changes the scene to the game scene, also unpauses the game if paused and updates game state to running
func change_scene_to_game():
	GameState.game_state = GameState.RUNNING
	GameState.unpause_game()
	change_scene(GAME)

## Changes scene to the main menu scene, also unpauses the game if paused and updates game state to menu
func change_scene_to_main_menu():
	GameState.game_state = GameState.MENU
	GameState.unpause_game()
	change_scene(MAIN_MENU);

## Changes a scene to the given scene path
func change_scene(scene_path: String):
	var packed_scene := load(scene_path)
	if not packed_scene:
		push_error("Failed to load scene: " + scene_path)
		return
	
	get_tree().change_scene_to_packed(packed_scene)

## Closes the game
func close_game():
	get_tree().quit();

## Reloads the current scene, also unpauses the game if paused
func reload():
	GameState.unpause_game()
	get_tree().reload_current_scene()
