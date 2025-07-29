extends Node
class_name DoorCameraTranslator

const limit_object: PackedScene = preload("res://src/Objects/Door/explosion_limit.tscn")

export  var debug_logs: bool = false
export  var boss_door: bool = false
export  var _previous_limit: NodePath
export  var _next_limit: NodePath
export  var _explosion_limit: NodePath
export  var associated_checkpoint: int = - 1
export  var exclusive_checkpoint: bool = false

onready var door: = get_parent()
onready var previous_limit: = get_node_or_null(_previous_limit)
onready var next_limit: = get_node_or_null(_next_limit)
onready var explosion_limit: = get_node_or_null(_explosion_limit)

var exploded: bool = false


func _ready() -> void :
	door.connect("explode", self, "on_explosion")
	door.connect("passing", self, "on_passing")
	door.connect("finish", self, "on_finish")
	door.connect("close", self, "on_close")
	Event.listen("moved_player_to_checkpoint", self, "on_checkpoint")
	if previous_limit:
		previous_limit.connect("accessed", self, "last_zone_entered")

func last_zone_entered() -> void :
	if not exploded and door.able_to_open:
		if previous_limit and not previous_limit.disabled and not next_limit.disabled:
			Log("last_zone_entered")
			disable_limits(next_limit)

func on_passing() -> void :
	Log("on passing")
	enable_limits(next_limit)
	disable_limits(previous_limit)
	update_limits(next_limit)
	door_translate_and_lock(door.global_position, next_limit, boss_door)

func on_explosion() -> void :
	Log("on explsion")
	exploded = true
	enable_explosion_limits()
	enable_limits(previous_limit)
	enable_limits(next_limit)
	update_limits(next_limit)
	translate(explosion_limit)

func on_finish() -> void :
	if boss_door:
		Event.emit_signal("show_warning")

func on_close() -> void :
	if exploded:
		Log("on close")
		disable_limits(previous_limit)
		disable_limits(explosion_limit)
		door_translate_and_lock(next_limit.global_position, next_limit, boss_door)

func on_checkpoint(checkpoint: CheckpointSettings) -> void :
	if associated_checkpoint == - 1:
		return
	if not exclusive_checkpoint:
		if checkpoint.id >= associated_checkpoint:
			enable_limits(next_limit)
			disable_limits(previous_limit)
	else:
		if checkpoint.id == associated_checkpoint:
			enable_limits(next_limit)
			disable_limits(previous_limit)

func disable_limits(limits) -> void :
	if limits:
		Log("disabling " + str(limits.name))
		limits.disable()
	else:
		Log("Unable to disable due to missing parameter.")

func enable_explosion_limits() -> void :
	if explosion_limit:
		Log("enabling explosion limit " + str(explosion_limit.name))
		explosion_limit.enable()
	else:
		Log("spawning and enabling explosion limits")
		var l = limit_object.instance()
		door.call_deferred("add_child", l)
		l.set_deferred("global_position", door.global_position)
		explosion_limit = l

func enable_limits(limits) -> void :
	if limits:
		Log("enabling " + str(limits.name))
		limits.enable()
	else:
		Log("Unable to enable due to missing parameter.")

func update_limits(limits) -> void :
	if limits:
		GameManager.camera.update_area_limits(limits)
	else:
		Log("Unable to update limits due to missing parameter.")

func door_translate_and_lock(_door_position: Vector2, destination_limits, should_lock: bool = false) -> void :
	if destination_limits:
		Log("translating to " + str(destination_limits.name))
		GameManager.camera.start_door_translate(destination_limits.global_position, destination_limits, should_lock)
	else:
		Log("Unable to door_translate_and_lock due to missing parameter.")

func translate(destination_limits) -> void :
	if destination_limits:
		Log("translating to " + str(destination_limits.name))
		if destination_limits.is_inside_tree():
			GameManager.camera.start_zonetranslate(destination_limits.position)
		else:
			GameManager.camera.start_zonetranslate(destination_limits.global_position)
	else:
		Log("Unable to translate due to missing parameter.")

func Log(message) -> void :
	if debug_logs:
		print(message)
