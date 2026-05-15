extends BaseFruitEatComponent

class_name JumpscareFruitEatComponent

const FRUIT_JUMPSCARE = preload("uid://cro8ucwb8nhf8")

func on_eat():
	var fruit_jumpscare = FRUIT_JUMPSCARE.instantiate()
	fruit.get_tree().current_scene.add_child(fruit_jumpscare)
	
	GameState.pause_game()
	
	var control_node = fruit_jumpscare.get_node("Control");
	
	var jumpscare_image : TextureRect = control_node.get_node("JumpscareImage");
	var jumpscare_sound : AudioStreamPlayer = control_node.get_node("JumpscareSound");
	var bunny_image : TextureRect = control_node.get_node("BunnyImage");
	var bunny_sound : AudioStreamPlayer = control_node.get_node("BunnySound");
	
	MusicPlayer.stop();
	
	if SaveManager.current_settings.jumpscares:
		jumpscare_image.show();
		jumpscare_sound.play();
		await jumpscare_sound.finished
		
	else:
		bunny_image.show();
		bunny_sound.play();
		await bunny_sound.finished
	
	fruit.level_manager.on_game_over()
