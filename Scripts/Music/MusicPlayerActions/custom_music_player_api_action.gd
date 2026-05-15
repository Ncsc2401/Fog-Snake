extends BaseMusicPlayerAPIAction

class_name CustomMusicAPIAction

@export var custom_musics : Array[AudioStream];

func action():
	MusicPlayer.set_custom_musics(custom_musics);
