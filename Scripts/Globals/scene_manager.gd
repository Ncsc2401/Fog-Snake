extends Node

const MAIN_MENU = "res://Scenes/main_menu.tscn"
const MAP = "res://Scenes/Map/map.tscn"

## Changes the scene to the game scene, also unpauses the game if paused and updates game state to running
func change_scene_to_level(level_scene : PackedScene):
	GameState.game_state = GameState.RUNNING
	change_scene_with_ps(level_scene);
	await Transition.TransitionEnded
	GameState.unpause_game()

## Changes the scene to the map also unpauses the game if paused and updates game state to map
func change_scene_to_map():
	GameState.game_state = GameState.MAP
	change_scene(MAP)
	await Transition.TransitionEnded
	GameState.unpause_game()

## Changes scene to the main menu scene, also unpauses the game if paused and updates game state to menu
func change_scene_to_main_menu():
	GameState.game_state = GameState.MENU
	change_scene(MAIN_MENU);
	await Transition.TransitionEnded
	GameState.unpause_game()

## Changes a scene to the given scene path
func change_scene(scene_path: String):
	var packed_scene := load(scene_path)
	if not packed_scene:
		push_error("Failed to load scene: " + scene_path)
		return
	
	Transition.go_in();
	
	await Transition.TransitionEnded
	
	get_tree().change_scene_to_packed(packed_scene)
	
	await get_tree().process_frame
	
	Transition.go_out();

func change_scene_with_ps(packed_scene : PackedScene):
	Transition.go_in();
	
	await Transition.TransitionEnded
	
	if packed_scene != null:
		get_tree().change_scene_to_packed(packed_scene)
	
	await get_tree().process_frame
	
	Transition.go_out();

## Closes the game
func close_game():
	get_tree().quit();

## Reloads the current scene, also unpauses the game if paused
func reload():
	Transition.go_in();
	
	await Transition.TransitionEnded
	
	get_tree().reload_current_scene()
	
	await get_tree().process_frame
	GameState.unpause_game()
	Transition.go_out();
