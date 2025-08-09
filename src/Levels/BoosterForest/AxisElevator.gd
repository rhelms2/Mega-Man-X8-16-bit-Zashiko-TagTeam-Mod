extends Node2D

export var max_variation := 120.0
export var speed := 50.0
var weight := 0
onready var left_elevator: RigidBody2D = $Elevator
onready var right_elevator: RigidBody2D = $Elevator2
onready var tween := TweenController.new(self,false)


func _ready() -> void:
	var _s
	_s = left_elevator.get_node("floor").connect("body_entered",self,"scale_weight",[-1])
	_s = left_elevator.get_node("floor").connect("body_exited",self,"scale_weight",[+1])
	_s = right_elevator.get_node("floor").connect("body_entered",self,"scale_weight",[+1])
	_s = right_elevator.get_node("floor").connect("body_exited",self,"scale_weight",[-1])


func scale_weight(body: Node, _weight : int) -> void:
	if is_ride_armor(body):
		weight += _weight
		tween_positions()

func is_ride_armor(_body: Node) -> bool:
	return _body.is_in_group("Props")
	
func tween_positions() -> void:
	match weight:
		-1: move()
		1: move()
		0: stop()

func move() -> void:
	tween.reset()
	var destination = max_variation*-weight
	var dur = get_duration(destination,left_elevator)
	tween.attribute("position:y",destination,dur,left_elevator)
	
	destination = max_variation*weight
	dur = get_duration(destination,right_elevator)
	tween.attribute("position:y",destination,dur,right_elevator)

func stop() -> void:
	tween.reset()

func get_duration(destination : float, elevator : Node2D) -> float:
	var current_pos = elevator.position.y
	return abs(destination - current_pos) / speed
