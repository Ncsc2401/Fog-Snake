extends LevelManager

@export var next_maze_level : PackedScene
@export var is_last_level : bool;

@export var jumpscare : Control;
@export var safe : Control

@export var jumpscare_sound : AudioStreamPlayer
@export var safe_sound : AudioStreamPlayer

@export var jumpscare_timer : Timer

func eat_fruit(pos : Vector2i) -> FruitResource:
	if !is_last_level:
		SceneManager.change_scene_with_ps(next_maze_level);
	else:
		# Save new data
		var new_data = MapLevelSaveableData.new();
		
		new_data.unlocked = true # Kinda redundant
		new_data.max_points = 666;
		new_data.max_size = 666
		new_data.least_time = 666;
		
		SaveManager.update_current_map_level_save(new_data);
		
		if SaveManager.current_settings.jumpscares:
			jumpscare.visible = true;
			jumpscare_sound.play();
		else:
			safe.visible = true;
			safe_sound.play();
		
		jumpscare_timer.start();
		GameState.pause_game();
	
	var fruit_resource = FruitResource.new()
	
	fruit_resource.points = 0;
	fruit_resource.size_increase = 0;
	
	return fruit_resource;
	

func on_game_over():	
	SceneManager.change_scene_to_map();


func _on_timer_timeout() -> void:
	SceneManager.change_scene_to_map()
