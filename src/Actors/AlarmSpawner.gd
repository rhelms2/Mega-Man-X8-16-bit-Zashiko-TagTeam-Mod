extends Node2D

export (PackedScene) var object_to_spawn
export var set_direction_to_right := false
export var detection_area : NodePath
var timer := 0.0
var alarm := false
var spawned_object : Node2D
var area

onready var visibility: VisibilityNotifier2D = $visibilityNotifier2D
func _ready() -> void:
	Event.listen("alarm",self,"on_alarm")
	Event.listen("turn_off_alarm",self,"on_reset_lights")
	call_deferred("set_area")

func set_area() -> void:
	area = get_node(detection_area)

func _physics_process(delta: float) -> void:
	if alarm and not is_instance_valid(spawned_object):
		timer += delta
		if timer > 0.35 and is_player_near():
			spawn()
			timer = 0
			alarm = false
	elif is_instance_valid(spawned_object):
		timer += delta
		if should_despawn():
			despawn()
			timer = 0
		

func is_player_near() -> bool:
	var sum = 0
	if GameManager.get_player_position().x < area.global_position.x + area.shape.extents.x:
		sum += 1
	if GameManager.get_player_position().x > area.global_position.x - area.shape.extents.x:
		sum += 1
	if GameManager.get_player_position().y < area.global_position.y + area.shape.extents.y:
		sum += 1
	if GameManager.get_player_position().y > area.global_position.y - area.shape.extents.y:
		sum += 1
	return sum == 4


func spawn() -> void:
	add_spawn_to_scene()
	position_spawn()
	timer = 0.01

func despawn() -> void:
	spawned_object.destroy()

func on_alarm() -> void:
	alarm = true
	timer = 0

func on_reset_lights() -> void:
	alarm = false

func add_spawn_to_scene() -> void:
	spawned_object = object_to_spawn.instance()
	get_tree().current_scene.get_node("Objects").call_deferred("add_child",spawned_object)

func position_spawn() -> void:
	spawned_object.transform = global_transform
	#spawned_object.global_position = global_position
	if spawned_object.has_method("set_direction"):
		if set_direction_to_right:
			spawned_object.call_deferred("set_direction",1)
		else:
			spawned_object.call_deferred("set_direction",-1)

func should_despawn() -> bool:
	return not GameManager.is_player_nearby(spawned_object) and not GameManager.is_on_screen(spawned_object.global_position) and timer > 8
