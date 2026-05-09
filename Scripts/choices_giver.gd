extends Node

const LADYBUG = preload("uid://bdnbplhqsw7jm")
const FLY = preload("uid://qxled4o5e5od")

const APPLE = preload("uid://48om1rvld52o")
const STAR_FRUIT = preload("uid://p5d6nykafa2t")
const WATERMELON = preload("uid://h3t2dvc0174k")
const ICE_CREAM = preload("uid://byayy2c7usui5")

var choices : Dictionary[String, Callable] = {
	"Spawn 4 ladybugs" : spawn_ladybugs,
	"Spawn 3 flies" : spawn_flies,
	"Grow snake" : grow_snakes,
	"Speed up game" : speed_game,
	"Invert movement" : invert_movement,
	"Lights out" : lights_out,
	"Spawn one more fruit" : spawn_one_more_fruit,
}

@onready var choices_menu: Control = $CanvasLayer/ChoicesMenu
@onready var choice_1_label: Label = $CanvasLayer/ChoicesMenu/MarginContainer/VBoxContainer/CenterContainer/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/Choice1
@onready var choice_2_label: Label = $CanvasLayer/ChoicesMenu/MarginContainer/VBoxContainer/CenterContainer/HBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/Choice2

@export var ticks_between_choices : int;

@export var fruit_spawner : FruitSpawner;
@export var enemy_spawner : EnemySpawner;
@export var snakes : Array[BaseSnake];
@export var level_manager : LevelManager;

var choice_1 : Callable;
var choice_2 : Callable;

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
	var choices_names = choices.keys();
	
	var choice_1_name = choices_names.pick_random();
	var choice_2_name = choices_names.pick_random();
	
	choice_1 = choices[choice_1_name];
	choice_2 = choices[choice_2_name];
	
	choice_1_label.text = choice_1_name
	choice_2_label.text = choice_2_name
	
	is_active = true;
	GameState.pause_game();
	choices_menu.show();

func _on_choice_1_button_pressed() -> void:
	choice_1.call()
	is_active = false;
	choices_menu.hide();
	GameState.unpause_game()
	GameState.game_state = GameState.RUNNING

func _on_choice_2_button_pressed() -> void:
	choice_2.call()
	is_active = false;
	choices_menu.hide()
	GameState.unpause_game()
	GameState.game_state = GameState.RUNNING

func spawn_ladybugs():
	for i in range(4):
		enemy_spawner.spawn_enemy_at(Vector2.ZERO, LADYBUG, 0, [BaseSpawner.RANDOM_POSITION_ATTRIBUTE]);

func grow_snakes():
	for snake in snakes:
		snake.expected_size += 5;

func speed_game():
	var new_game_speed = max(0.01, level_manager.game_tick_time - 0.05);
	
	ticks_between_choices = ceil(ticks_between_choices * level_manager.game_tick_time / new_game_speed) 
	
	level_manager.change_game_speed(new_game_speed)
	
	if new_game_speed == 0.01:
		choices.erase("Speed up game");

func spawn_flies():
	for i in range(3):
		enemy_spawner.spawn_enemy_at(Vector2.ZERO, FLY, 0, [BaseSpawner.RANDOM_POSITION_ATTRIBUTE]);

func invert_movement():
	for snake in level_manager.snakes:
		var inverted_input_component = InvertedSnakeInputComponent.new()
		snake.input_component = inverted_input_component
		inverted_input_component.initialize(snake);
		
	choices.erase("Invert movement")

func lights_out():
	for snake in level_manager.snakes:
		var light_system_component = LightSystemComponent.new()
		snake.misc_components.append(light_system_component);
		light_system_component.initialize(snake);
	
	choices.erase("Lights out")

func spawn_one_more_fruit():
	for spawner in level_manager.spawners:
		if spawner is FruitSpawner:
			spawner.spawn_fruit_at(Vector2.ZERO, null, 0, [BaseSpawner.RANDOM_POSITION_ATTRIBUTE, BaseSpawner.RANDOM_SCENE_ATTRIBUTE]);
