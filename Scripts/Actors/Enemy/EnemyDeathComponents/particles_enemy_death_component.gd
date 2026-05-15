extends BaseEnemyDeathComponent

class_name ParticleEnemyDeathComponent

const ENEMY_DEATH_PARTICLES = preload("uid://dnbis0hyb6sf4")

func on_death():
	var enemy_death_particles = ENEMY_DEATH_PARTICLES.instantiate()
	enemy.get_tree().current_scene.add_child(enemy_death_particles);
	enemy_death_particles.global_position = enemy.global_position
	enemy_death_particles.emit();
