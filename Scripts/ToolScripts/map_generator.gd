@tool
extends Node2D

@export_tool_button("Generate map", "Callable") var generate_action = generate 
@export_tool_button("Clear map", "Callable") var clear_map = clear;

## Distance in pixels between levels
@export var level_distance : float;

## First level and used as a pivot
@export var first_level : MapLevelData

@onready var levels: Node2D = $Map/Levels
@onready var bridges: Node2D = $Map/Bridges

const BONUS_LEVEL_SPRITE = preload("uid://ch4cacj4aahvn")
const CHALLENGE_LEVEL_SPRITE = preload("uid://hy72aiisyle")
const NORMAL_LEVEL_SPRITE = preload("uid://dp8p6vthbrpei")
const SPECIAL_LEVEL_SPRITE = preload("uid://c0yio3pgcwhw7")
const SECRET_LEVEL_SPRITE = preload("uid://dl4peag3h6r65")

const NORMAL_BRIDGE_COLOR = Color(1, 1, 1);
const CHALLENGE_BRIDGE_COLOR = Color(1, 0, 0);
const BONUS_BRIDGE_COLOR = Color(1, 0.9568, 0);
const SPECIAL_BRIDGE_COLOR = Color(0, 0.0862, 1);
const SECRET_BRIDGE_COLOR = Color(0.1, 0.1, 0.1)

const MAP_LEVEL = preload("uid://choe75140jiq0")
const MAP_LEVEL_BRIDGE = preload("uid://c0rqbb431ixkx")

## Increases by 1 every time it is used
var unique_id : int= 0;

func generate():
	var id_data_table = get_id_data_table()
	var data_pos = get_data_pos()
	clear();
	generate_nodes(data_pos, id_data_table);
	generate_bridges(data_pos, id_data_table);
	set_data_pos(data_pos, id_data_table);

func generate_nodes(data_pos : Dictionary[int, Vector2i], id_data_table : Dictionary[int, MapLevelData]):
	for level_id in id_data_table:
		# Creating map level node
		var map_level_node : MapLevel = MAP_LEVEL.instantiate();
		
		# Initializing level node
		map_level_node.level_data = id_data_table[level_id];
		map_level_node.global_position = data_pos[level_id] * level_distance;
			
		# Adding level node to tree
		levels.add_child(map_level_node);
		
		# Changing its name if possible
		if id_data_table[level_id].level_name.is_valid_filename():
			map_level_node.name = id_data_table[level_id].level_name;
			
		# Setting so it appears in the editor
		map_level_node.owner = get_tree().edited_scene_root;
		
		# Setting level node icon | Trying to access map_level_node.map_icon.texutre results in a error.
		var map_icon = map_level_node.get_node("Sprite2D")
		match id_data_table[level_id].level_type:
			id_data_table[level_id].LevelType.NORMAL:
				map_icon.texture = NORMAL_LEVEL_SPRITE;
			id_data_table[level_id].LevelType.BONUS:
				map_icon.texture = BONUS_LEVEL_SPRITE;
			id_data_table[level_id].LevelType.CHALLENGE:
				map_icon.texture = CHALLENGE_LEVEL_SPRITE;
			id_data_table[level_id].LevelType.SPECIAL:
				map_icon.texture = SPECIAL_LEVEL_SPRITE;
			id_data_table[level_id].LevelType.SECRET:
				map_icon.texture = SECRET_LEVEL_SPRITE;

func generate_bridges(data_pos : Dictionary[int, Vector2i], id_data_table : Dictionary[int, MapLevelData]):
	var bridged_levels : Array[int];

	for level_id in id_data_table.keys():
		var to_bridge_level = id_data_table[level_id];
		
		var around_data : Array[MapLevelData] = [
			to_bridge_level.up_level,
			to_bridge_level.left_level,
			to_bridge_level.down_level,
			to_bridge_level.right_level
		]
		
		for data in around_data:
			if data != null && !bridged_levels.has(data.id):
				var bridge : MapLevelBridge = MAP_LEVEL_BRIDGE.instantiate();
				bridge.add_point(data_pos[level_id] * level_distance);
				bridge.add_point(data_pos[data.id] * level_distance);
				
				bridges.add_child(bridge);
				
				bridge.to = data;
				
				# Setting level bridge color
				match data.level_type:
					data.LevelType.NORMAL:
						bridge.default_color = NORMAL_BRIDGE_COLOR;
					data.LevelType.BONUS:
						bridge.default_color = BONUS_BRIDGE_COLOR;
					data.LevelType.CHALLENGE:
						bridge.default_color = CHALLENGE_BRIDGE_COLOR;
					data.LevelType.SPECIAL:
						bridge.default_color = SPECIAL_BRIDGE_COLOR;
					data.LevelType.SECRET:
						bridge.default_color = SECRET_BRIDGE_COLOR;
						
				bridge.owner = get_tree().edited_scene_root
				
		bridged_levels.append(to_bridge_level.id)

## Returns a dictionary representing the data positions must be called after get_id_data_table()
func get_data_pos() -> Dictionary[int, Vector2i]:
	var data_pos : Dictionary[int, Vector2i];
	
	data_pos[first_level.id] = Vector2i(0, 0);
	
	## All resources yet to be checked
	var to_check_data : Array[MapLevelData];
	
	to_check_data.append(first_level)
	
	# Traversing all data by its neighbours
	while to_check_data.size() > 0:
		var checking_data : MapLevelData = to_check_data.pop_front();
		
		var up_level = checking_data.up_level;
		var down_level = checking_data.down_level;
		var right_level = checking_data.right_level;
		var left_level = checking_data.left_level;

		if up_level != null && !data_pos.has(up_level.id):
			data_pos[up_level.id] = data_pos[checking_data.id] + Vector2i(0, -1);
			to_check_data.append(up_level);
		if down_level != null && !data_pos.has(down_level.id):
			data_pos[down_level.id] = data_pos[checking_data.id] + Vector2i(0, 1);
			to_check_data.append(down_level);
		if left_level != null && !data_pos.has(left_level.id):
			data_pos[left_level.id] = data_pos[checking_data.id] + Vector2i(-1, 0);
			to_check_data.append(left_level);
		if right_level != null && !data_pos.has(right_level.id):
			data_pos[right_level.id] = data_pos[checking_data.id] + Vector2i(1, 0);
			to_check_data.append(right_level);
			
	return data_pos;

## Set up
func set_data_pos(data_pos : Dictionary[int, Vector2i], id_data_table : Dictionary[int, MapLevelData]):
	for level_id in id_data_table.keys():
		id_data_table[level_id].pos = data_pos[level_id]

## Returns a id data table map
func get_id_data_table() -> Dictionary[int, MapLevelData]:
	var to_check_levels : Array[MapLevelData];
	
	var id_data_table : Dictionary[int, MapLevelData];
	
	to_check_levels.append(first_level);
	
	while to_check_levels.size() > 0:
		var to_check_level = to_check_levels.pop_front();
		
		var around_data : Array[MapLevelData] = [
			to_check_level.up_level,
			to_check_level.left_level,
			to_check_level.down_level,
			to_check_level.right_level
		]
		
		for data in around_data:
			if data != null:
				to_check_levels.append(data);
		
		to_check_level.id = unique_id;
		unique_id += 1;
		id_data_table[to_check_level.id] = to_check_level;
	
	return id_data_table;

func clear():
	unique_id = 0;
	for node in levels.get_children():
		node.queue_free()
	for node in bridges.get_children():
		node.queue_free();
