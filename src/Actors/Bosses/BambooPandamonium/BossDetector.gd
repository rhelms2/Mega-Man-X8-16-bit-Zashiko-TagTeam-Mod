extends Area2D

signal boss_detected
func _on_area2D_body_entered(_body: Node) -> void :
	if abs(_body.get_horizontal_speed()) > 100:
		emit_signal("boss_detected")
