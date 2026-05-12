extends BaseGetDataComponent

class_name GetEnemyDataComponent

enum DataField {
	BOARD_POSITION,
	KILLS_ON_DEATH,
	POINTS_ON_DEATH,
	ENEMY_NAME,
}

@export var data_field : DataField

func set_brain_key_to_store():
	if has_custom_key_value():
		brain_key_to_store = custom_key_value;
		return
	
	match data_field:
		DataField.BOARD_POSITION:
			brain_key_to_store = "EnemyBoardPositionMemory"
		DataField.KILLS_ON_DEATH:
			brain_key_to_store = "EnemyKillsOnDeathMemory"
		DataField.POINTS_ON_DEATH:
			brain_key_to_store = "EnemyPointsOnDeathMemory"
		DataField.ENEMY_NAME:
			brain_key_to_store = "EnemyNameMemory"

func can_do_action() -> bool:
	if !actor.brain.has_brain_key("EnemyInMemory"):
		return false;
	
	var enemy = actor.brain.get_from_brain("EnemyInMemory");
	
	if enemy is not Enemy:
		return false;
	
	if !is_instance_valid(enemy):
		return false
	
	return true;

func get_data():
	var enemy : Enemy = actor.brain.get_from_brain("EnemyInMemory");
	
	match data_field:
		DataField.BOARD_POSITION:
			return enemy.board_position;
		DataField.KILLS_ON_DEATH:
			return enemy.l_enemy_resource.kills_on_death
		DataField.POINTS_ON_DEATH:
			return enemy.l_enemy_resource.points_on_death
		DataField.ENEMY_NAME:
			return enemy.l_enemy_resource.enemy_name
