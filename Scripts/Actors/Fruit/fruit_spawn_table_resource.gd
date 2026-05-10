extends Resource

class_name FruitSpawnTableResource

@export var spawn_table : Array[FruitSpawnTableEntryResource];

func get_total_weight():
	var total : float = 0;
	for entry in spawn_table:
		total += entry.weight;
	
	return total;
