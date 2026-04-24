@abstract
extends Node2D

class_name BaseSpawner

class SpawnRequest:
	var pos : Vector2i;
	var is_random_pos : bool;
	var is_random_scene : bool;
	var scene : PackedScene;
	
	func _init(pos : Vector2i, scene : PackedScene, is_random_pos : bool, is_random_scene : bool):
		self.pos = pos;
		self.scene = scene;
		self.is_random_scene = is_random_scene;
		self.is_random_pos = is_random_pos

var spawn_requests : Array[SpawnRequest];

@abstract
func spawn_commit();

@abstract
func clear_requests()
