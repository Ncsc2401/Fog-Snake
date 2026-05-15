extends Node

class_name MusicPlayerClass

@onready var player_1: AudioStreamPlayer = $Player1
@onready var player_2: AudioStreamPlayer = $Player2

var players : Array[AudioStreamPlayer]

var current_player : AudioStreamPlayer;
var current_music : AudioStream;

var tween: Tween;

enum PlaybackStyles {
	RANDOM, ## Plays a random music from internal lib
	REPEAT, ## Plays the same music again
	STOP, ## Goes silent
	RANDOM_CUSTOM ## Plays a random music from a custom lib
}

## What should it do when music ends
var playback_style : PlaybackStyles = PlaybackStyles.RANDOM;

# I dont have any musics right now
var musics = [
]

var custom_musics = [
]

func _ready() -> void:
	if !musics.is_empty():
		player_1.stream = musics.pick_random()
		player_1.play();
	
	players = [player_1, player_2];
	current_player = player_1;

## Returns the player that is not the current one
func get_other_player() -> AudioStreamPlayer:
	if current_player == player_1:
		return player_2
	elif current_player == player_2:
		return player_1
	
	return null;

func set_custom_musics(new_custom_musics : Array[AudioStream]):
	custom_musics = new_custom_musics;

func set_playback_style(new_playback_style : PlaybackStyles):
	playback_style = new_playback_style;

func change_music_to(music : AudioStream):
	if music == current_music:
		return;
	
	current_music = music
	
	if tween != null:
		delete_tween()
	
	tween = create_tween();
	
	var previous_player = current_player;
	var next_player = get_other_player();
	
	next_player.stream = music;
	
	next_player.play()
	
	current_player = next_player;
	
	tween.parallel().tween_property(previous_player, "volume_db", -80, 5);
	tween.parallel().tween_property(next_player, "volume_db", 0, 5);
	
	await tween.finished
	previous_player.stop();

func on_music_ended():
	match playback_style:
		PlaybackStyles.RANDOM:
			if musics.is_empty():
				return;
			change_music_to(musics.pick_random());
			
		PlaybackStyles.REPEAT:
			current_player.seek(0);
			current_player.play()
			
		PlaybackStyles.STOP:
			return;
		
		PlaybackStyles.RANDOM_CUSTOM:
			if custom_musics.is_empty():
				return;
				
			change_music_to(custom_musics.pick_random());

func _on_player_1_finished() -> void:
	if current_player != player_1:
		return;
	
	on_music_ended();

func _on_player_2_finished() -> void:
	if current_player != player_2:
		return;
	
	on_music_ended();

func stop():
	if tween != null:
		tween.kill()
	
	tween = create_tween();
	
	tween.tween_property(current_player, "volume_db", -80, 1.5);
	
	await tween.finished
	current_player.stop();

func reset():
	custom_musics = [];
	playback_style = PlaybackStyles.RANDOM;
	if !current_music in musics:
		stop()
		#change_music_to(musics.pick_random())

func delete_tween():
	if tween != null:
		tween.kill();
		tween = null;
