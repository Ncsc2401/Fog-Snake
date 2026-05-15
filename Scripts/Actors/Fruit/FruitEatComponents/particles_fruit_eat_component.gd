extends BaseFruitEatComponent

class_name ParticlesFruitEatParticles

const FRUIT_EAT_PARTICLES = preload("uid://qavg853sbi05")

func on_eat():
	var fruit_eat_particles = FRUIT_EAT_PARTICLES.instantiate();
	fruit.get_tree().current_scene.add_child(fruit_eat_particles);
	fruit_eat_particles.global_position = fruit.global_position;
	fruit_eat_particles.emit();
