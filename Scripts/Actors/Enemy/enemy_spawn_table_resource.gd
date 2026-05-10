extends Resource

class_name EnemySpawnTableResource

@export var spawn_table : Array[EnemySpawnTableEntryResource];

func get_total_weight():
	var total : float = 0;
	for entry in spawn_table:
		total += entry.weight;
	
	return total;
