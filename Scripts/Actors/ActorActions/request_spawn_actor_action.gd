extends BaseActorAction

class_name RequestSpawnActorAction

func can_do_action() -> bool:
	if !actor.brain.has_brain_key("ToSpawnPos"):
		return false;
	
	var to_spawn_scene = actor.brain.get_from_brain("ToSpawnScene")
	
	if to_spawn_scene == null:
		return false;
	
	if !actor.brain.has_brain_key("TicksToSpawn"):
		return false;
	
	if !actor.brain.has_brain_key("ToSpawnAttributes"):
		return false;
	
	return true;

func do_action():
	var to_spawn_pos = actor.brain.get_from_brain("ToSpawnPos");
	var to_spawn_scene = actor.brain.get_from_brain("ToSpawnScene")
	var ticks_to_spawn = actor.brain.get_from_brain("TicksToSpawn")
	var to_spawn_attributes = actor.brain.get_from_brain("ToSpawnAttributes")
	
	actor.actor_spawner.spawn_at(to_spawn_pos, to_spawn_scene, ticks_to_spawn, to_spawn_attributes)
