@abstract
extends Node2D

class_name BaseSpawner

enum SpawnRequestAttributes{
	RAND_POS,
	RAND_SCENE,
	WARNS_BEFORE_SPAWNING
}

const RANDOM_POSITION_ATTRIBUTE = SpawnRequestAttributes.RAND_POS;
const RANDOM_SCENE_ATTRIBUTE = SpawnRequestAttributes.RAND_SCENE;
const WARNS_BEFORE_SPAWNING = SpawnRequestAttributes.WARNS_BEFORE_SPAWNING;

enum SpawnRequestStatus {
	STATUS_UNPROCESSED,
	STATUS_WAITING,
	STATUS_READY,
	STATUS_FAILED,
	STATUS_FINISHED
}

const STATUS_UNPROCESSED = SpawnRequestStatus.STATUS_UNPROCESSED
const STATUS_WAITING = SpawnRequestStatus.STATUS_WAITING
const STATUS_READY = SpawnRequestStatus.STATUS_READY
const STATUS_FAILED = SpawnRequestStatus.STATUS_FAILED
const STATUS_FINISHED = SpawnRequestStatus.STATUS_FINISHED;

class SpawnRequest:
	var attributes : Array;
	
	var pos : Vector2i;
	var scene : PackedScene;
	var ticks_to_spawn : int;
	
	var status : SpawnRequestStatus = STATUS_UNPROCESSED;
	
	func _init(pos : Vector2i, scene : PackedScene, ticks_to_spawn : int, attributes : Array):
		self.pos = pos;
		self.scene = scene;
		self.ticks_to_spawn = ticks_to_spawn;
		self.attributes = attributes.duplicate();

var spawn_requests : Array[SpawnRequest];

func process_requests():
	for spawn_request in spawn_requests:
		# Skip finished requests
		if spawn_request.status == STATUS_FINISHED:
			continue;
		
		# Decrease ticks to spawn
		spawn_request.ticks_to_spawn -= 1;
		
		# Set spawn request status
		if spawn_request.ticks_to_spawn > 0:
			spawn_request.status = STATUS_WAITING;
		elif spawn_request.ticks_to_spawn <= 0:
			spawn_request.status = STATUS_READY;
		
		var status = spawn_request.status;
		
		# Solve attributes
		for attribute in spawn_request.attributes:
			match attribute:
				RANDOM_POSITION_ATTRIBUTE:
					if status == STATUS_READY:
						if get_random_position() == null:
							spawn_request.status = STATUS_FAILED;
							continue
						spawn_request.pos = get_random_position()
				RANDOM_SCENE_ATTRIBUTE:
					if status == STATUS_READY:
						spawn_request.scene = get_random_scene()
				_:
					solve_custom_attibutes(attribute, spawn_request);

@abstract
func spawn_commit();

func clear_requests():
	var indeces_to_remove : Array[int];
	
	for i in range(spawn_requests.size()):
		if spawn_requests[i].status == STATUS_FINISHED or spawn_requests[i].status == STATUS_FAILED:
			indeces_to_remove.append(i);
	
	indeces_to_remove.reverse();
	
	for i in indeces_to_remove:
		spawn_requests.remove_at(i);

@abstract
func get_random_scene() -> PackedScene

## Should return a Vector2 or null if failed
@abstract
func get_random_position()

@abstract
func solve_custom_attibutes(attibute : SpawnRequestAttributes, spawn_request : SpawnRequest);

## A generic spawn function, prefer to use the class specific alternatives
@abstract
func spawn_at(pos : Vector2i, enemy_scene : PackedScene, ticks_to_spawn : int, attributes : Array[SpawnRequestAttributes])
