extends Node2D

class_name LevelManager

var points = 0;
var won : bool = false;
var winning_tick;

@export var board_data : BoardData

@export var win_condition : BaseWinCondition

## Amount of secods for each tick
@export var initial_game_tick_time : float = 0.20

var game_tick_time : float = 0;

## Stores the history of the game_tick_time in a dict in the form game_tick_time : ticks
var game_tick_time_history : Dictionary[float, float];
var game_tick_time_starting_tick : int = 0;

@export var game_over_menu : Control;
@export var score_ui : Control

var walls : Array[Vector2i];
var fruits : Array[BaseFruit]
var spawners : Array[BaseSpawner]
var snakes : Array[BaseSnake];
var enemies : Array[BaseEnemy];

func _ready() -> void:
	await get_tree().process_frame
	
	win_condition.level_manager = self
	points = 0;
	change_game_speed(initial_game_tick_time)
	
	if board_data == null:
		push_error("Board data is null on " + name);
		return;
	
	# Set up walls
	for cell_pos in board_data.board.keys():
		if board_data.board[cell_pos] == BoardData.WALL:
			walls.append(cell_pos);

	for snake in snakes:
		snake.GameOver.connect(on_game_over);
	
	GlobalSignals.Tick.connect(tick_logic)
	
	pre_spawn()
	
func on_game_over():
	if game_over_menu:
		# Display game over menu
		game_over_menu.activate();
	
	if SaveManager.current_level == null:
		push_warning("Current level save is null")
		return;
	
	# Save new data
	var new_data = MapLevelSaveableData.new();
		
	new_data.unlocked = true # Kinda redundant
	new_data.max_points = points;
	var biggest_size = -1
	for snake in snakes:
		if snake.body_size > biggest_size:
			biggest_size = snake.body_size;
	new_data.max_size = biggest_size
	
	new_data.total_tries = SaveManager.current_level.get_saveable_data().total_tries + 1;
	new_data.least_time = -1
	# Unlock levels
	if won:
		SaveManager.unlock_current_surrounding_levels();
		new_data.least_time = calculate_game_time()
		new_data.tries_to_win = new_data.total_tries;
		new_data.won = true;
	
	SaveManager.update_current_map_level_save(new_data);

func check_victory():
	if win_condition.check_win() && !won:
		won = true;
		winning_tick = GlobalSignals.ticks;

func tick_logic():
	for enemy in enemies:
		enemy.on_tick();
	
	# Fruits may move
	for fruit in fruits:
		fruit.on_tick();
	
	# Snake moves
	for snake in snakes:
		snake.move();
	
	# Enemy dies
	for enemy in enemies:
		if enemy.just_died:
			enemy.on_die_call();
	
	# Snake eats
	for fruit in fruits.duplicate():
		if fruit.was_eaten:
			continue
		
		for snake in snakes:
			if fruit.pos == snake.head.pos:
				points += fruit.fruit_resource.points
				if score_ui == null:
					push_warning("Score ui is null")
				else:
					update_score_display()
				snake.eat_fruit(fruit.fruit_resource);
				fruit.on_eat_call()
	
	# Snake grows
	for snake in snakes:
		snake.grow();
	
	check_victory()
	
	# Snake dies
	for snake in snakes:
		# Check walls
		if walls.has(snake.head.pos):
			snake.die()
			continue
		
		# Check out of bounds
		if !board_data.board.has(snake.head.pos):
			snake.die()
			continue
		
		for enemy in enemies:
			if snake.head.pos == enemy.board_pos:
				snake.die()
				continue;
		
		# Check for snake
		var snake_collided_with_snake : bool = false;
		for snake_2 in snakes:
			for body_segment in snake_2.snake_body:
				if body_segment == snake.head:
					continue;
				if body_segment.pos == snake.head.pos:
					snake.die()
					snake_collided_with_snake = true;
					break;
			if snake_collided_with_snake:
				break;
	
	# Draws snake
	for snake in snakes:
		snake.clear_snake()
		snake.draw_snake()
	
	# Spawners spawn
	for spawner in spawners:
		spawner.spawn_commit();
		spawner.clear_requests()

func update_score_display():
	score_ui.update_display(points)

func pre_spawn():
	for spawner in spawners:
		spawner.spawn_commit()
		spawner.clear_requests()

func change_game_speed(new_speed : float):
	var delta_tick  = GlobalSignals.ticks - game_tick_time_starting_tick;
	if !game_tick_time_history.has(game_tick_time):
		game_tick_time_history[game_tick_time] = delta_tick
	else:
		game_tick_time_history[game_tick_time] += delta_tick;
	game_tick_time_starting_tick = GlobalSignals.ticks;
	
	game_tick_time = new_speed;
	GlobalSignals.tick_time = game_tick_time

func calculate_game_time():
	var time = 0;
	for key in game_tick_time_history.keys():
		time += key * game_tick_time_history[key];
	
	var current_delta_time = (GlobalSignals.ticks - game_tick_time_starting_tick) * game_tick_time;
	
	time += current_delta_time
	
	return time;

func get_empty_spaces() -> Array[Vector2i]:
	var empty_spaces : Array[Vector2i] = [];
	
	if board_data == null:
		push_warning("Board data is null")
		return empty_spaces;
	
	# Get all board free spaces
	for board_pos in board_data.board.keys():
		if board_data.board[board_pos] == BoardData.EMPTY:
			empty_spaces.append(board_pos);
	
	# Remove spaces occupied by fruits
	for fruit in fruits:
		empty_spaces.erase(fruit.pos);
	
	# Remove spaces occupied by enemies
	for enemy in enemies:
		empty_spaces.erase(enemy.board_pos);
	
	# Remove spaces occupied by snakes
	for snake in snakes:
		for snake_segment in snake.snake_body:
			empty_spaces.erase(snake_segment.pos);
	
	return empty_spaces;

## Returns if space is empty and valid (not a wall, not out of bounds, not occupied)
func is_space_empty(pos : Vector2i) -> bool:
	if board_data == null:
		push_warning("Board data is null")
		return false;
	
	if !board_data.board.has(pos):
		return false;
	
	if walls.has(pos):
		return false;
	
	for fruit in fruits:
		if fruit.pos == pos:
			return false;
	
	for snake in snakes:
		for body_segment in snake.snake_body:
			if body_segment.pos == pos:
				return false;
	
	for enemy in enemies:
		if enemy.board_pos == pos:
			return false;
	
	return true;

## Returns if space has enemy
func has_space_enemy(pos : Vector2i) -> bool:
	for enemy in enemies:
		if pos == enemy.board_pos:
			return true;
		
	return false;

## Returns if space is wall
func is_space_wall(pos : Vector2i) -> bool:
	return walls.has(pos);

## Returns if space is in bounds
func is_space_in_bounds(pos : Vector2i) -> bool:
	if board_data == null:
		push_warning("Board data is null")
		return false;
	
	return board_data.board.has(pos);
