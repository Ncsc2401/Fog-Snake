extends Resource

class_name MapLevelData

enum LevelType{
	NORMAL,
	CHALLENGE,
	BONUS,
	SPECIAL,
	SECRET
};

## Position in map grid
@export_storage var pos : Vector2i

## Id for map_generator
@export_storage var id : int = -1;

@export var save_name : String;

@export_subgroup("Level data")
@export var level_name : String;
@export var objective : String;
@export var level_scene : PackedScene;
@export var level_type : LevelType;

@export_subgroup("Navigation")
# Levels unlocked when you beat this level also used to map navigation
@export var left_level : MapLevelData;
@export var right_level : MapLevelData;
@export var up_level : MapLevelData;
@export var down_level : MapLevelData;

# Saveable data
func get_saveable_data() -> MapLevelSaveableData:
	if save_name.is_empty() || !save_name.is_valid_filename():
		push_warning("No valid save name")
		return
	
	return SaveManager.get_map_level_save(save_name);
