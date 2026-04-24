extends Node

enum GameStates{
	PAUSED = 0,
	RUNNING = 1,
	MENU = 2,
	GAMEOVER = 3,
	MAP = 4,
	LEVEL_INTRO = 5
}

## Game state when game is paused
const PAUSED = GameStates.PAUSED
## Game state when game is running
const RUNNING = GameStates.RUNNING
## Game state when in main menu
const MENU = GameStates.MENU
## Game state when game is over
const GAMEOVER = GameStates.GAMEOVER
## Game state when in map
const MAP = GameStates.MAP
## Game state when in level intro
const LEVEL_INTRO = GameStates.LEVEL_INTRO

## Current game state
var game_state : GameStates = MENU;

var is_in_transition : bool = false;

## Pauses the game and update game state
func pause_game():
	get_tree().paused = true;
	game_state = PAUSED;

## Unpauses the game
func unpause_game():
	get_tree().paused = false;
