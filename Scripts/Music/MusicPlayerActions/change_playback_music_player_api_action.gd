extends BaseMusicPlayerAPIAction

class_name ChangePlaybackMusicAPIAction

@export var new_playback : MusicPlayerClass.PlaybackStyles;

func action():
	MusicPlayer.set_playback_style(new_playback);
