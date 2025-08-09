extends Node2D


func _ready() -> void :
	Event.call_deferred("emit_signal", "intro_x")
	pass
