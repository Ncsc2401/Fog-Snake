extends Node2D

class_name MapLevel

@onready var map_icon: Sprite2D = $Sprite2D

## Level data
@export var level_data : MapLevelData

const BONUS_LEVEL_SPRITE = preload("uid://ch4cacj4aahvn")
const CHALLENGE_LEVEL_SPRITE = preload("uid://hy72aiisyle")
const NORMAL_LEVEL_SPRITE = preload("uid://dp8p6vthbrpei")
const SPECIAL_LEVEL_SPRITE = preload("uid://c0yio3pgcwhw7")
const SECRET_LEVEL_SPRITE = preload("uid://dl4peag3h6r65")

func _ready():
	set_sprite();

func set_sprite():
	match level_data.level_type:
		level_data.LevelType.NORMAL:
			map_icon.texture = NORMAL_LEVEL_SPRITE;
		level_data.LevelType.BONUS:
			map_icon.texture = BONUS_LEVEL_SPRITE;
		level_data.LevelType.CHALLENGE:
			map_icon.texture = CHALLENGE_LEVEL_SPRITE;
		level_data.LevelType.SPECIAL:
			map_icon.texture = SPECIAL_LEVEL_SPRITE;
		level_data.LevelType.SECRET:
			map_icon.texture = SECRET_LEVEL_SPRITE;
