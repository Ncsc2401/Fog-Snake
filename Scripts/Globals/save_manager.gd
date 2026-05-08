extends Node

const SAVE_LEVELS_PATH = "user://save/levels/"
const SAVE_SETTINGS_PATH = "user://save/"
const SETTINGS_FILE_NAME = "settings"

var multi_level_save_data : MapLevelSaveableData;
var multi_level_first_level_in_chain : PackedScene;

var current_settings : SettingsData;
var current_level : MapLevelData;

var last_focused_level_pos : Vector2i;

func _init() -> void:
	current_level = MapLevelData.new()
	
	current_level.objective = "NULL"
	current_level.level_name = "NULL"
	
	load_settings()
	apply_settings()

## Creates a new map level save
func create_map_level_save(save_name : String):
	if !DirAccess.dir_exists_absolute(SAVE_LEVELS_PATH):
		DirAccess.make_dir_recursive_absolute(SAVE_LEVELS_PATH)
	
	var level_save_path = SAVE_LEVELS_PATH + save_name;
	var level_save = FileAccess.open(level_save_path, FileAccess.WRITE)
	
	var unlocked = false;
	var least_time = -1;
	var max_points = -1;
	var max_size = -1;
	var total_tries = 0;
	var tries_to_win = -1;
	var won = false;
	
	level_save.store_var(unlocked);
	level_save.store_var(least_time);
	level_save.store_var(max_points);
	level_save.store_var(max_size);
	level_save.store_var(total_tries);
	level_save.store_var(tries_to_win);
	level_save.store_var(won);
	
	level_save.close()

## Updates an already existing save
func update_map_level_save(save_name : String, new_data : MapLevelSaveableData):
	if !DirAccess.dir_exists_absolute(SAVE_LEVELS_PATH):
		DirAccess.make_dir_recursive_absolute(SAVE_LEVELS_PATH)
	
	var level_save_path = SAVE_LEVELS_PATH + save_name;
	
	var current_data = get_map_level_save(save_name);
	var level_save = FileAccess.open(level_save_path, FileAccess.WRITE)
	
	level_save.store_var(new_data.unlocked);
	
	# Least time
	if (new_data.least_time < current_data.least_time ||\
	current_data.least_time == -1) &&\
	new_data.least_time != -1:
		level_save.store_var(new_data.least_time);
	else:
		level_save.store_var(current_data.least_time);
	
	# Max points
	if new_data.max_points > current_data.max_points || current_data.max_points == -1:
		level_save.store_var(new_data.max_points);
	else:
		level_save.store_var(current_data.max_points);
	
	# Max size
	if new_data.max_size > current_data.max_size || current_data.max_size == -1:
		level_save.store_var(new_data.max_size);
	else:
		level_save.store_var(current_data.max_size);
	
	# Total tries
	level_save.store_var(new_data.total_tries);
	
	# Tries to win
	if current_data.tries_to_win == -1 && new_data.won:
		level_save.store_var(new_data.tries_to_win)
	else:
		level_save.store_var(current_data.tries_to_win);
	
	# Won
	if current_data.won:
		level_save.store_var(current_data.won)
	else:
		level_save.store_var(new_data.won);
	
	level_save.close()

## Update the current level save
func update_current_map_level_save(new_data : MapLevelSaveableData):
	update_map_level_save(current_level.save_name, new_data);

## Unlocks a level
func unlock_level(save_name : String):
	var data = get_map_level_save(save_name);
	
	var new_data = MapLevelSaveableData.new()
	
	new_data.unlocked = true;
	new_data.max_points = data.max_points
	new_data.max_size = data.max_size
	new_data.least_time = data.least_time;
	new_data.total_tries = data.total_tries
	new_data.tries_to_win = data.tries_to_win
	new_data.won = data.won;

	update_map_level_save(save_name, new_data);

func unloack_all():
	var dir = DirAccess.open(SAVE_LEVELS_PATH)
	
	for level in dir.get_files():
		unlock_level(level);

## Unlocks all surrounding levels
func unlock_current_surrounding_levels():
	var around_levels : Array[MapLevelData] = [
		current_level.down_level,
		current_level.left_level,
		current_level.up_level,
		current_level.right_level
	]
		
	for level in around_levels:
		if level == null:
			continue
		unlock_level(level.save_name)

## Returns a level save
func get_map_level_save(save_name : String):
	var data = MapLevelSaveableData.new();
	
	var level_save_path = SAVE_LEVELS_PATH + save_name;
	
	if !FileAccess.file_exists(level_save_path):
		create_map_level_save(save_name);
	
	var save = FileAccess.open(level_save_path, FileAccess.READ)
	data.unlocked = save.get_var();
	data.least_time = save.get_var();
	data.max_points = save.get_var();
	data.max_size = save.get_var();
	data.total_tries = save.get_var();
	data.tries_to_win = save.get_var();
	data.won = save.get_var()
	
	save.close();
	
	return data;

func has_save():
	var dir = DirAccess.open(SAVE_LEVELS_PATH);
	
	if dir == null:
		return false;
	
	var has_files : bool = false;
	
	for file in dir.get_files():
		has_files = true;
		break;
	
	return has_files;

## Delete all saves
func wipe_save():
	var dir = DirAccess.open(SAVE_LEVELS_PATH)
	for file in dir.get_files():
		dir.remove(file)

func save_settings(settings_data : SettingsData):
	if !DirAccess.dir_exists_absolute(SAVE_SETTINGS_PATH):
		DirAccess.make_dir_recursive_absolute(SAVE_SETTINGS_PATH)
	
	var settings_file_path = SAVE_SETTINGS_PATH + SETTINGS_FILE_NAME;
	var settings_file = FileAccess.open(settings_file_path, FileAccess.WRITE);
	
	settings_file.store_var(settings_data.music_volume);
	settings_file.store_var(settings_data.sound_effects_volume);
	settings_file.store_var(settings_data.ambiance_volume)
	settings_file.store_var(settings_data.jumpscares);
	settings_file.store_var(settings_data.full_screen);
	
	current_settings = settings_data
	apply_settings()

func save_settings_field(new_value, field : SettingsData.SettingsFields):
	match field:
		SettingsData.SettingsFields.MUSIC_VOLUME:
			current_settings.music_volume = new_value;
		SettingsData.SettingsFields.SOUND_EFFECTS_VOLUME:
			current_settings.sound_effects_volume = new_value;
		SettingsData.SettingsFields.AMBIANCE_VOLUME:
			current_settings.ambiance_volume = new_value;
		SettingsData.SettingsFields.JUMPSCARES:
			current_settings.jumpscares = new_value;
		SettingsData.SettingsFields.FULL_SCREEN:
			current_settings.full_screen = new_value;
	
	save_settings(current_settings);

func load_settings():
	var settings_file_path = SAVE_SETTINGS_PATH + SETTINGS_FILE_NAME;
	var settings_data = SettingsData.new();
	
	if FileAccess.file_exists(settings_file_path):
		var settings_file = FileAccess.open(settings_file_path, FileAccess.READ);
		
		settings_data.music_volume = settings_file.get_var();
		settings_data.sound_effects_volume = settings_file.get_var();
		settings_data.ambiance_volume = settings_file.get_var();
		settings_data.jumpscares = settings_file.get_var();
		settings_data.full_screen = settings_file.get_var()
		
		settings_file.close();
	
	else:
		settings_data.music_volume = 0.5;
		settings_data.sound_effects_volume = 0.5;
		settings_data.ambiance_volume = 0.5;
		settings_data.jumpscares = true;
		settings_data.full_screen = false;
	
	current_settings = settings_data;

func apply_settings():
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Music"),
		linear_to_db(current_settings.music_volume)
	)
	
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Sound Effects"),
		linear_to_db(current_settings.sound_effects_volume)
	)
	
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Ambiance"),
		linear_to_db(current_settings.ambiance_volume)
	)
	
	if current_settings.full_screen && DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN);
	elif !current_settings.full_screen && DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED);
