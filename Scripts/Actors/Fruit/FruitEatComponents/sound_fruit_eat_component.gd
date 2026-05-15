extends BaseFruitEatComponent

class_name SoundFruitEatComponent

@export var eat_sound : AudioStream;

func on_eat():
	var audio_node = SoundNode.new(eat_sound, SoundNode.AudioBuses.SOUND_EFFECTS);
	
	fruit.get_tree().current_scene.add_child(audio_node);
	
	audio_node.play();
