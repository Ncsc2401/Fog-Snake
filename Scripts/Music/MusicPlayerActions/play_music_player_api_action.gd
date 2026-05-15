extends BaseMusicPlayerAPIAction

class_name PlayMusicAPIAction

@export var music : AudioStream;

func action():
	MusicPlayer.change_music_to(music);
