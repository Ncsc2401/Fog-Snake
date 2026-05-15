extends Node

# Enemies
const BIPOLAR_BALL = preload("uid://bykg1yrcnsi46")
const EYE = preload("uid://up5ykhpgcpq5")
const FLY = preload("uid://qxled4o5e5od")
const KNIGHT = preload("uid://dd8bsum2sf2qo")
const LADYBUG = preload("uid://bdnbplhqsw7jm")
const NUTCRACKER = preload("uid://kgrlrl453bow")
const SPIDER = preload("uid://b0hrkqmtgu7f6")

# Fruits

const APPLE = preload("uid://48om1rvld52o")
const BANANA = preload("uid://rix1qbmvsuw5")
const COFFEE = preload("uid://dgm1x2ukk01m1")
const ICE_CREAM = preload("uid://byayy2c7usui5")
const PIZZA = preload("uid://dmyeosgdon7sk")
const SLEEPING_PILLS = preload("uid://jb52fn0u5xki")
const STAR_FRUIT = preload("uid://p5d6nykafa2t")
const WATERMELON = preload("uid://h3t2dvc0174k")

enum Rarities {
	COMMON,
	RARE,
	EPIC,
	LEGENDARY,
	SPECIAL
}

const COMMON = Rarities.COMMON
const RARE = Rarities.RARE
const EPIC = Rarities.EPIC
const LEGENDARY = Rarities.LEGENDARY
const SPECIAL = Rarities.SPECIAL

var rarity_to_text = {
	COMMON : "Common",
	RARE : "Rare",
	EPIC : "Epic",
	LEGENDARY : "Legendary",
	SPECIAL : "Special"
}

var rarity_to_color = {
	COMMON : Color.WHITE,
	RARE : Color.YELLOW,
	EPIC : Color.WEB_PURPLE,
	LEGENDARY : Color.CORAL,
	SPECIAL : Color.LIGHT_BLUE,
}

class Choice:
	var description : String;
	var func_call : Callable;
	var chance : float;
	var rarity : Rarities;
	var func_args : Array
	
	func _init(rarity : Rarities, description : String, func_call : Callable, chance : float, func_args = []) -> void:
		self.rarity = rarity;
		self.description = description;
		self.func_call = func_call;
		self.chance = chance
		self.func_args = func_args

var choices : Array[Choice] = [
	Choice.new(
		Rarities.COMMON,
		"Grow +3",
		grow_snakes,
		3,
		[3]
	),
	Choice.new(
		Rarities.COMMON,
		"Spawn 3 ladybugs",
		spawn_ladybugs,
		4,
		[3]
	),
	Choice.new(
		Rarities.COMMON,
		"Spawn 2 flies",
		spawn_flies,
		4,
		[2]
	),
	Choice.new(
		Rarities.COMMON,
		"Spawn 4 nutcrackers",
		spawn_nutcrackers,
		4,
		[4]
	),
	Choice.new(
		Rarities.RARE,
		"Speed up",
		speed_game,
		2
	),
	Choice.new(
		Rarities.RARE,
		"Spawn 5 ladybugs",
		spawn_ladybugs,
		2,
		[5]
	),
	Choice.new(
		Rarities.RARE,
		"Spawn 4 flies",
		spawn_flies,
		2,
		[4]
	),
	Choice.new(
		Rarities.RARE,
		"Spawn 2 knights",
		spawn_knights,
		2,
		[2]
	),
	Choice.new(
		Rarities.RARE,
		"Spawn 1 spider",
		spawn_spiders,
		2,
		[2]
	),
	Choice.new(
		Rarities.RARE,
		"Grow +5",
		grow_snakes,
		2,
		[5]
	),
	Choice.new(
		Rarities.EPIC,
		"Spawn 4 spiders",
		spawn_spiders,
		0.5,
		[4]
	),
	Choice.new(
		Rarities.EPIC,
		"Do nothing",
		nothing,
		0.5
	),
	Choice.new(
		Rarities.EPIC,
		"Spawn 1 fruit",
		spawn_fruits,
		0.5,
		[1]
	),
	Choice.new(
		Rarities.EPIC,
		"Invert movement",
		invert_movement,
		0.5
	),
	Choice.new(
		Rarities.EPIC,
		"Grow + 7",
		grow_snakes,
		0.5,
		[7]
	),
	Choice.new(
		Rarities.EPIC,
		"Spawn 6 nutcrackers",
		spawn_nutcrackers,
		0.5,
		[6]
	),
	Choice.new(
		Rarities.SPECIAL,
		"Lights out",
		lights_out,
		0.05
	),
	Choice.new(
		Rarities.SPECIAL,
		"Spawn 20 fruits",
		spawn_fruits,
		0.05,
		[20]
	),
	Choice.new(
		Rarities.SPECIAL,
		"Grow forever",
		grow_snakes,
		0.05,
		[400]
	),
	Choice.new(
		Rarities.SPECIAL,
		"Close game",
		close_game,
		0.05
	),
]

@onready var choices_menu: Control = $CanvasLayer/ChoicesMenu
@onready var rarity_1_label: Label = $CanvasLayer/ChoicesMenu/MarginContainer/VBoxContainer/CenterContainer/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer2/Rarity1
@onready var choice_1_label: Label = $CanvasLayer/ChoicesMenu/MarginContainer/VBoxContainer/CenterContainer/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/Choice1
@onready var rarity_2_label: Label = $CanvasLayer/ChoicesMenu/MarginContainer/VBoxContainer/CenterContainer/HBoxContainer/PanelContainer2/MarginContainer/VBoxContainer2/Rarity2
@onready var choice_2_label: Label = $CanvasLayer/ChoicesMenu/MarginContainer/VBoxContainer/CenterContainer/HBoxContainer/PanelContainer2/MarginContainer/VBoxContainer2/VBoxContainer/Choice2

@export var ticks_between_choices : int;

@export var fruit_spawner : FruitSpawner;
@export var enemy_spawner : EnemySpawner;
@export var snakes : Array[Snake];
@export var level_manager : LevelManager;

var choice_1 : Choice 
var choice_2 : Choice

var is_active : bool = false;

var tick : int = 0;

func _ready() -> void:
	GlobalSignals.Tick.connect(on_tick);
	
func on_tick():
	if is_active:
		return
	
	tick += 1;
	if tick >= ticks_between_choices:
		give_choice();
		tick = 0;

func give_choice():
	var total_weight = choices.reduce(
		func(accum, choice : Choice): return accum + choice.chance,
		0
	);
	
	var choice_1_pos = randf_range(0, total_weight);
	
	var pos = 0;
	for choice in choices:
		pos += choice.chance;
		if pos > choice_1_pos:
			choice_1 = choice;
			break;
	
	choice_2 = choice_1;
	while choice_2 == choice_1:
		var choice_2_pos = randf_range(0, total_weight);
		
		pos = 0;
		for choice in choices:
			pos += choice.chance;
			if pos > choice_2_pos:
				choice_2 = choice;
				break;
	
	rarity_1_label.text = rarity_to_text[choice_1.rarity]
	rarity_2_label.text = rarity_to_text[choice_2.rarity]
	rarity_1_label.modulate = rarity_to_color[choice_1.rarity]
	rarity_2_label.modulate = rarity_to_color[choice_2.rarity]
	
	choice_1_label.text = choice_1.description
	choice_2_label.text = choice_2.description
	
	is_active = true;
	GameState.pause_game();
	choices_menu.show();

## TODO: Should probabily fix the func args thing

func _on_choice_1_button_pressed() -> void:
	if choice_1.func_args.is_empty():
		choice_1.func_call.call();
	else:
		choice_1.func_call.call(choice_1.func_args[0]);
	is_active = false;
	choices_menu.hide();
	GameState.unpause_game()
	GameState.game_state = GameState.RUNNING

func _on_choice_2_button_pressed() -> void:
	if choice_2.func_args.is_empty():
		choice_2.func_call.call();
	else:
		choice_2.func_call.call(choice_2.func_args[0]);;
	is_active = false;
	choices_menu.hide()
	GameState.unpause_game()
	GameState.game_state = GameState.RUNNING

func remove_from_choices(func_call : Callable):
	var choices_to_remove = []
	for i in range(choices.size()):
		if choices[i].func_call == func_call:
			choices_to_remove.append(i);
	
	choices_to_remove.reverse();
	
	for index in choices_to_remove:
		choices.remove_at(index);

func spawn_ladybugs(amount : int):
	for i in range(amount):
		enemy_spawner.spawn_enemy_at(Vector2.ZERO, LADYBUG, 0, [BaseSpawner.RANDOM_POSITION_ATTRIBUTE]);

func spawn_flies(amount : int):
	for i in range(amount):
		enemy_spawner.spawn_enemy_at(Vector2.ZERO, FLY, 0, [BaseSpawner.RANDOM_POSITION_ATTRIBUTE]);

func spawn_knights(amount : int):
	for i in range(amount):
		enemy_spawner.spawn_enemy_at(Vector2.ZERO, KNIGHT, 0, [BaseSpawner.RANDOM_POSITION_ATTRIBUTE]);

func spawn_nutcrackers(amount : int):
	for i in range(amount):
		enemy_spawner.spawn_enemy_at(Vector2.ZERO, NUTCRACKER, 0, [BaseSpawner.RANDOM_POSITION_ATTRIBUTE]);

func spawn_spiders(amount : int) : 
	for i in range(amount):
		enemy_spawner.spawn_enemy_at(Vector2.ZERO, SPIDER, 0, [BaseSpawner.RANDOM_POSITION_ATTRIBUTE]);

func grow_snakes(amount : int):
	for snake in snakes:
		snake.expected_size += amount;

func speed_game():
	var new_game_speed = max(0.01, level_manager.game_tick_time - 0.05);
	
	ticks_between_choices = ceil(ticks_between_choices * level_manager.game_tick_time / new_game_speed) 
	
	level_manager.change_game_speed(new_game_speed)
	
	if new_game_speed == 0.01:
		remove_from_choices(speed_game);

func nothing():
	pass

func invert_movement():
	for snake in level_manager.snakes:
		var inverted_input_component = InvertedSnakeInputComponent.new()
		snake.l_input_component = inverted_input_component
		inverted_input_component.initialize(snake);
		
	remove_from_choices(invert_movement);

func lights_out():
	for snake in level_manager.snakes:
		var light_system_component = LightSystemComponent.new()
		snake.l_misc_components.append(light_system_component);
		light_system_component.initialize(snake);
	
	remove_from_choices(lights_out)

func spawn_fruits(amount : int):
	for spawner in level_manager.spawners:
		if spawner is FruitSpawner:
			for i in range(amount):
				spawner.spawn_fruit_at(Vector2.ZERO, null, 0, [BaseSpawner.RANDOM_POSITION_ATTRIBUTE, BaseSpawner.RANDOM_SCENE_ATTRIBUTE]);
			return;

func close_game():
	SceneManager.close_game();
