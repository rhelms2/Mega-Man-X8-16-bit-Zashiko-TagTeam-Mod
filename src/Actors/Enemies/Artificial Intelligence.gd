extends Node2D
class_name ArtificialIntelligence

onready var character := get_parent()
onready var detector := $player_detector

export var player_control := false
var target_list = []
var last_action := 0
var current_action := 0

signal go_left
signal go_right
signal go_up
signal go_down
signal attack

var timer := 0.0

func _ready() -> void:
# warning-ignore:return_value_discarded
	get_parent().connect("ability_end",self,"next_step")
# warning-ignore:return_value_discarded
	detector.connect("body_entered",self,"on_body_entered")
# warning-ignore:return_value_discarded
	detector.connect("body_exited",self,"on_body_exited")

func _physics_process(delta: float) -> void:
	if player_control:
		process_controls()
		return
	
	if target_list.size() > 0:
		respond_to_player_nearby(delta)
	else:
		action_for_no_nearby_player(delta)


func respond_to_damage(_inflicter):
	pass

func respond_to_player_nearby(_delta: float):
	pass

func action_for_no_nearby_player(_delta: float):
	pass

func next_step(ability) -> void:
	if ability is Attack:
		last_action += 1


func target_to_the_right() -> bool:
	return global_position.x < target_list[0].global_position.x

func target_to_the_left() -> bool:
	return target_list[0].global_position.x < global_position.x

func artificial_input(command):
	emit_signal(command)
	current_action += 1
	

func process_controls():
	if Input.is_action_pressed("move_left"):
		emit_signal("go_left")
	if Input.is_action_pressed("move_right"):
		emit_signal("go_right")
	if Input.is_action_pressed("jump"):
		emit_signal("go_up")
	if Input.is_action_pressed("move_down"):
		emit_signal("go_down")
	if Input.is_action_pressed("fire"):
		emit_signal("attack")


func on_body_entered(body: Node) -> void:
	if body.is_in_group("Player") and not body.is_in_group("Props") :
		add_to_visible_list(body)

func on_body_exited(body: Node) -> void:
	if body.is_in_group("Player") and not body.is_in_group("Props") :
		remove_from_visible_list(body)

func add_to_visible_list(_body: Node) -> void:
	if not (_body in target_list):
		target_list.append(_body)

func remove_from_visible_list(_target: Node):
	if _target in target_list:
		target_list.erase(_target)
