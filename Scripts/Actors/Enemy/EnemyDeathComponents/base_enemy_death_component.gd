@abstract
extends Resource

class_name BaseEnemyDeathComponent

var enemy : Enemy;

func initialize(enemy : Enemy):
	self.enemy = enemy;

@abstract
func on_death();
