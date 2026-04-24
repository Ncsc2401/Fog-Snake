extends Node

@export var cheat_codes : Dictionary[CheatCodeCommand, CheatCodeCall];

var cheat_codes_action_map : Dictionary[int, CheatCodeCall];
var cheat_codes_commands : Dictionary[int, Array];

var cheat_codes_progresses : Dictionary[int, Array];

@onready var cheat_code_display: Label = $CanvasLayer/CheatCodeActions/MarginContainer/VBoxContainer/CheatCodeDisplay
@onready var cheat_code_display_animation_player: AnimationPlayer = $CanvasLayer/CheatCodeActions/MarginContainer/VBoxContainer/CheatCodeDisplay/CheatCodeDisplayAnimationPlayer

func _ready():
	var index = 0;
	for key in cheat_codes.keys():
		cheat_codes_commands[index] = key.command;
		cheat_codes_action_map[index] = cheat_codes[key];
		index += 1;
	
	cheat_codes_progresses = cheat_codes_commands.duplicate(true);

func _input(event: InputEvent) -> void:
	if event is InputEventKey && event.is_pressed() and !event.is_echo():
		test_for_cheat_code(event)

func test_for_cheat_code(event : InputEvent):
	var event_string = event.as_text().to_lower();
	
	for i in cheat_codes_commands.keys():
		if cheat_codes_progresses[i][0] == event_string:
			cheat_codes_progresses[i].remove_at(0);
			if cheat_codes_progresses[i].size() <= 0:
				call_cheat_code(cheat_codes_action_map[i]);
				cheat_codes_progresses[i] = cheat_codes_commands[i].duplicate();
		
		else:
			cheat_codes_progresses[i] = cheat_codes_commands[i].duplicate();

func call_cheat_code(cheat_code_call : CheatCodeCall):
	var node = get_node(cheat_code_call.node_path);
	
	if cheat_code_call.function_args.size() <= 0:
		node.call(cheat_code_call.function_name);
	else:
		node.call(cheat_code_call.function_name, cheat_code_call.function_args);
	
	cheat_code_display.text = cheat_code_call.cheat_code_display_text;
	cheat_code_display_animation_player.play("AppearAndFade");
