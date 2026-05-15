extends BaseSnakeMiscComponent

class_name MoveSoundSnakeComponent

@export var up_sound : AudioStream
@export var down_sound : AudioStream
@export var left_sound : AudioStream
@export var right_sound : AudioStream

func on_death():
	pass

func on_move(direction : Snake.Directions):
	if direction == snake.last_direction:
		return;
	
	var move_sound : AudioStream
	match direction:
		Snake.Directions.UP:
			move_sound = up_sound;
		Snake.Directions.DOWN:
			move_sound = down_sound
		Snake.Directions.LEFT:
			move_sound = left_sound
		Snake.Directions.RIGHT:
			move_sound = right_sound
		_:
			return;
	
	if move_sound == null:
		return;
	
	var sound_node = SoundNode.new(move_sound, SoundNode.AudioBuses.SOUND_EFFECTS);
	
	snake.get_tree().current_scene.add_child(sound_node);
	
	sound_node.play();

func on_process(delta : float):
	pass

func on_eat(fruit_resource : FruitResource):
	pass

func on_initialize():
	pass

func on_grow():
	pass
