extends Node
class_name Locale

var position : Vector2
var animation : String
var time : float

func _init(_position := Vector2.ZERO, _animation := "idle", _time :=0.0) -> void:
	position = _position
	animation = _animation
	time = _time
