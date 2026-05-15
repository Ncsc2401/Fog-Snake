extends BaseSnakeMiscComponent

class_name DeathSoundSnakeComponent

@export var death_sound : AudioStream

func on_death():
	if death_sound == null:
		push_warning("No death sound");
		return;
	
	var sound_node = SoundNode.new(death_sound, SoundNode.AudioBuses.SOUND_EFFECTS);
	
	snake.get_tree().current_scene.add_child(sound_node);
	
	sound_node.play();

func on_move(direction : Snake.Directions):
	pass

func on_process(delta : float):
	pass

func on_eat(fruit_resource : FruitResource):
	pass

func on_initialize():
	pass

func on_grow():
	pass
