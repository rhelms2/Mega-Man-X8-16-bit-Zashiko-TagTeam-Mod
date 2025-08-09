extends Node

onready var camera: Camera2D = $".."

var target: = Vector2.ZERO
var current: = Vector2.ZERO
var tween: SceneTreeTween


func _ready() -> void :
	Event.listen("camera_offset", self, "on_receive_offset")

func on_receive_offset(_target, duration: = 0.5) -> void :
	if target != _target:
		target = _target
		start_transition(duration)

func update(position, _delta) -> Vector2:
	return position + current

func start_transition(duration) -> void :
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(camera, "camera_offset", target, duration).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
