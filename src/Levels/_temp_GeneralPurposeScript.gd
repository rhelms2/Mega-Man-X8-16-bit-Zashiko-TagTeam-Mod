extends Node2D

var b := false

func _physics_process(_delta: float) -> void:
	if not b:
		Event.emit_signal("boss_door_closed")
		b = true
