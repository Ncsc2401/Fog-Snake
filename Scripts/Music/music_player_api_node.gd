extends Node

class_name MusicPlayerAPINode

@export var music_player_api_actions : Array[BaseMusicPlayerAPIAction];

func _ready() -> void:
	for music_player_api_action in music_player_api_actions:
		music_player_api_action.action();
