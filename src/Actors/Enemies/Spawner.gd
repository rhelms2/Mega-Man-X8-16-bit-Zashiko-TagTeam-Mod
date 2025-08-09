extends Node2D

const time_between_spawns := 3.0
export var spawn_on_start := false
var despawn_time := 0.0
var spawned_object

func _ready() -> void:
	if spawn_on_start:
		call_deferred("spawn")

func spawn() -> void:
	pass

func _on_visibilityNotifier2D_screen_entered() -> void:
	if not is_instance_valid(spawned_object):
		if get_time() > respawn_time():
			spawn()

func _on_spawnedObject_queue_free() -> void:
	despawn_time = get_time()

func respawn_time() -> float:
	return despawn_time + time_between_spawns

func get_time() -> float:
	return float(OS.get_ticks_msec())/1000
