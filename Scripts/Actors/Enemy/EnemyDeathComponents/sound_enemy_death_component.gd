extends BaseEnemyDeathComponent

class_name SoundEnemyDeathComponent

@export var death_sound : AudioStream;

func on_death():
	var sound_node = SoundNode.new(death_sound, SoundNode.AudioBuses.SOUND_EFFECTS);
	
	enemy.get_tree().current_scene.add_child(sound_node);
	
	sound_node.play();
