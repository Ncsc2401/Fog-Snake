extends Node

class_name SoundController

@export var active : bool = true;

## All audio player and their respective sound name.
var audio_stream_players : Dictionary[String, AudioStreamPlayer];

func _ready() -> void:
	await get_tree().process_frame
	for child in get_children():
		if child is AudioStreamPlayer:
			audio_stream_players[child.name.to_lower()] = child;

func play_sound(sound_name : String):
	if !active:
		return
	
	var sound_name_normalized : String = sound_name.to_lower()
	if !audio_stream_players.has(sound_name_normalized):
		push_warning("No sound named " + sound_name + " was found.");
		return
	audio_stream_players[sound_name_normalized].play();
