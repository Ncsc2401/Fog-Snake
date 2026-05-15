extends Node2D

class_name SoundNode

var audio_stream_player: AudioStreamPlayer;

enum AudioBuses {
	MUSIC,
	AMBIANCE,
	SOUND_EFFECTS
}

var audio : AudioStream

func _init(audio : AudioStream, audio_bus : AudioBuses) -> void:
	audio_stream_player = AudioStreamPlayer.new()
	
	self.audio = audio;
	
	match audio_bus:
		AudioBuses.MUSIC:
			audio_stream_player.bus = &"Music"
		AudioBuses.AMBIANCE:
			audio_stream_player.bus = &"Ambiance"
		AudioBuses.SOUND_EFFECTS:
			audio_stream_player.bus = &"Sound Effects"

func play():
	add_child(audio_stream_player);
	audio_stream_player.stream = audio
	
	audio_stream_player.play();
	
	await audio_stream_player.finished
	
	queue_free();

static func play_sound(audio : AudioStream, bus : AudioBuses, tree : SceneTree):
	var sound_node = SoundNode.new(audio, bus);
	tree.current_scene.add_child(sound_node)
	sound_node.play()
