extends Node


func _ready() -> void :
	Event.call_deferred("emit_signal", "disable_exit")
