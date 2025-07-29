extends Node2D
class_name Darkness


func _on_playerDetector_body_entered(_body: Node) -> void :
	Event.emit_signal("darkness")

func _on_playerDetector_body_exited(_body: Node) -> void :
	Event.emit_signal("turn_off_darkness")
