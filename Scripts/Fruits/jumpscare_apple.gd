extends BaseFruit

@onready var jumpscare_image: TextureRect = $CanvasLayer/Control/Jumpscare2
@onready var bunny_image: TextureRect = $CanvasLayer/Control/Bunny2

@onready var jumpscare_sound: AudioStreamPlayer = $CanvasLayer/Control/Jumpscare
@onready var bunny_sound: AudioStreamPlayer = $CanvasLayer/Control/Bunny

func on_eat():
	GameState.pause_game()
	
	if SaveManager.current_settings.jumpscares:
		jumpscare_image.show();
		jumpscare_sound.play();
		await jumpscare_sound.finished
		
	else:
		bunny_image.show();
		bunny_sound.play();
		await bunny_sound.finished
	
	(level_manager as MultiLevelManager).update_multi_level_data();
	(level_manager as MultiLevelManager).commit_multi_level_data();
	
	SceneManager.change_scene_to_map();
	
func on_fruit_tick():
	pass
