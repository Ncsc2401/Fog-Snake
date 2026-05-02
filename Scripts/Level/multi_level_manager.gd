extends LevelManager

class_name MultiLevelManager

@export_file("*.tscn") var first_level_in_chain : String;
@export var next_level : PackedScene
@export var is_last_level : bool;
@export var is_first_level : bool;

func _ready() -> void:
	super();
	
	await get_tree().process_frame
	
	if is_first_level:
		create_multi_level_data();
	
	for snake in snakes:
		snake.expected_size = SaveManager.multi_level_save_data.max_size - snake.body_size;
	
	update_score_display();
	
	# Change game over variables
	game_over_menu.reload_current_scene = false;
	game_over_menu.play_again_scene = load(first_level_in_chain);

func on_game_over():
	if game_over_menu:
		# Display game over menu
		game_over_menu.activate();
	
	if SaveManager.current_level == null:
		push_warning("Current level save is null")
		return;
	
	if SaveManager.multi_level_save_data == null:
		push_warning("Multi level data is null");
		return;
	
	update_multi_level_data();
	
	commit_multi_level_data();

func check_victory():
	if !win_condition.check_win():
		return
	
	winning_tick = GlobalSignals.ticks
	
	if is_last_level:
		won = true;
		return;
	
	update_multi_level_data();
	
	SceneManager.change_scene_to_level(next_level);
	GameState.pause_game();

func update_score_display():
	score_ui.update_display(points + SaveManager.multi_level_save_data.max_points)

func create_multi_level_data():
	if !is_first_level:
		return;
		
	var multi_level_data = MapLevelSaveableData.new();
		
	multi_level_data.unlocked = true;
	multi_level_data.least_time = -1;
	multi_level_data.max_points = 0;
	
	var biggest_size = -1;
	for snake in snakes:
		if snake.body_size > biggest_size:
			biggest_size = snake.body_size;
	multi_level_data.max_size = biggest_size;
	
	multi_level_data.tries_to_win = -1;
	multi_level_data.won = false;
	
	SaveManager.multi_level_save_data = multi_level_data;

func update_multi_level_data():
	if SaveManager.multi_level_save_data == null:
		push_warning("Multi level data is null");
		return;
	
	SaveManager.multi_level_save_data.max_points += points;
	
	var biggest_size = -1;
	for snake in snakes:
		if snake.body_size > biggest_size:
			biggest_size = snake.body_size;
	
	if SaveManager.multi_level_save_data.max_size < biggest_size:
		SaveManager.multi_level_save_data.max_size = biggest_size;
	
	if won:
		if SaveManager.multi_level_save_data.least_time == -1:
			SaveManager.multi_level_save_data.least_time = 0;
		SaveManager.multi_level_save_data.least_time += calculate_game_time()

func commit_multi_level_data():
	var new_data = MapLevelSaveableData.new();
		
	new_data.unlocked = true
	new_data.max_points = SaveManager.multi_level_save_data.max_points;
	new_data.max_size = SaveManager.multi_level_save_data.max_size;
	new_data.total_tries = SaveManager.current_level.get_saveable_data().total_tries + 1;
	new_data.least_time = -1;
	
	# Unlock levels
	if won and is_last_level:
		SaveManager.unlock_current_surrounding_levels();
		new_data.least_time = SaveManager.multi_level_save_data.least_time;
		new_data.tries_to_win = SaveManager.current_level.get_saveable_data().total_tries;
		new_data.won = true;
	
	SaveManager.update_current_map_level_save(new_data);
