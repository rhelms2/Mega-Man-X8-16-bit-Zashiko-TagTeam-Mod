extends Node2D
class_name Spawner

export var active := true
export var debug_logs := false
export var debug_extra_info := false
export (PackedScene) var object_to_spawn
export var spawn_at_start := false
export var precise_area_spawn := false
export var make_child_of_this_object := false
export var wait_time_before_respawn := 6.0
export var set_direction_to_right := true
export var start_inverted := false
export var despawnable := true
export var connect_teleport_events := true
export var active_time_offscreen := 8.0
var has_spawned_once := false
var has_spawned := false
var timer := 0.0
var time_of_spawn := 0.0
var time_of_death := 0.0
var time_outside_screen := 0.0
var spawned_object : Node2D
var debug_shutdown := false


export var custom_vars : Dictionary

onready var visibility = $visibilityNotifier2D

signal object_death
signal actual_enemy_death

func _ready() -> void:
	Log("Spawner Created. Active Status: " + str(active))
	Log("Object to spawn: " + str(object_to_spawn))
	connect_stage_teleport_events()
	if debug_shutdown:
		return
	if active and spawn_at_start:
		Log("spawning at start")
		spawn()

func connect_stage_teleport_events():
	if connect_teleport_events:
		Log("Connecting teleport events")
		Event.connect("stage_teleport",self,"deactivate")
		Event.connect("stage_teleport_end",self,"activate")
	

func deactivate() -> void:
	Log("Deactivating")
	active = false

func activate() -> void:
	Log("Activating")
	active = true

func print_extra_info() -> void:
	print_debug("Processing...")
	print_debug(spawned_object)

func _physics_process(delta: float) -> void:
	if debug_shutdown:
		set_process(false)
		return
	if debug_extra_info:
		print_extra_info() 
	if active:
		timer += delta
		if not has_spawned:
			if met_spawn_conditions():
				Log("Respawn conditions met")
				spawn()
		elif is_instance_valid(spawned_object):
			if should_despawn():
				Log("Despawning")
				despawn() 
			else:
				if GameManager.is_on_screen(spawned_object.global_position):
					time_outside_screen = 0
				else:
					time_outside_screen += delta
		else:
			has_spawned = false

func met_spawn_conditions() -> bool:
	return  not should_wait() and should_spawn() and not is_on_first_second()

func should_spawn() -> bool:
	if precise_area_spawn:
		return not GameManager.precise_is_on_screen(global_position) and GameManager.is_player_nearby(self)
	return not GameManager.is_on_screen(global_position) and GameManager.is_player_nearby(self)

func should_wait() -> bool:
	if wait_time_before_respawn > 0 and has_spawned_once:
		Log("Waiting for time to respawn")
		return timer < time_of_death + wait_time_before_respawn
	else:
		return false

func should_despawn() -> bool:
	return despawnable and not GameManager.is_player_nearby(self) and not GameManager.is_on_screen(spawned_object.global_position) and time_outside_screen > active_time_offscreen

func despawn() -> void:
	if is_instance_valid(spawned_object):
		Log(name + ": despawning " + spawned_object.name)
		spawned_object.destroy()
		has_spawned = false

func is_on_first_second() -> bool:
	return timer < 1

func spawn() -> void:
	Log("spawning... ")
	add_spawn_to_scene()
	position_spawn()
	setup_custom_variables()
	has_spawned = true
	has_spawned_once = true
	time_of_spawn = timer
	time_outside_screen = 0
	if spawned_object.has_signal("spawned_child"):
		spawned_object.connect("spawned_child",self,"object_spawned_child")# warning-ignore:return_value_discarded
	spawned_object.connect("zero_health",self,"on_object_death")# warning-ignore:return_value_discarded
	spawned_object.connect("death",self,"emit_signal",["actual_enemy_death"])# warning-ignore:return_value_discarded
	call_deferred("debug_info")

func respawn() -> void:
	despawn()
	call_deferred("spawn")
	
func debug_info() -> void:
	Log("spawned " + spawned_object.name + " at " + str(spawned_object.global_position))
	Log("child of " + spawned_object.get_parent().name + " at " + str(spawned_object.get_parent().global_position))

func setup_custom_variables() -> void:
	for key in custom_vars.keys():
		Log(name+ ": Setting property '" +key + "' to '" + str(custom_vars[key]) + "' in " + spawned_object.name)
		spawned_object.set(key,custom_vars[key])

func add_spawn_to_scene() -> void:
	spawned_object = object_to_spawn.instance()
	if make_child_of_this_object:
		get_parent().call_deferred("add_child",spawned_object)
	else:
		get_tree().current_scene.get_node("Objects").call_deferred("add_child",spawned_object)

func on_object_death() ->void:
	has_spawned = false
	time_of_death = timer
	emit_signal("object_death")

func object_spawned_child(spawned_child,should_despawn = true) -> void:
	despawnable = should_despawn
	on_object_spawn(spawned_child)

func on_object_spawn(spawned_child) ->void:
	has_spawned = true
	spawned_object = spawned_child
	spawned_object.connect("zero_health",self,"on_object_death")# warning-ignore:return_value_discarded
	time_of_death = 0.0
	time_outside_screen = 0

func position_spawn() -> void:
	if make_child_of_this_object:
		spawned_object.transform = transform
	else:
		spawned_object.transform = global_transform

	if spawned_object.has_method("spawner_set_direction"):
		if set_direction_to_right:
			spawned_object.call_deferred("spawner_set_direction",1,true)
		else:
			spawned_object.call_deferred("spawner_set_direction",-1,true)

	if start_inverted:
		spawned_object.scale.y = -1

var last_message
func Log(msg) -> void:
	if msg != last_message and debug_logs:
		print_debug(name + ": " + msg)
		last_message = msg
