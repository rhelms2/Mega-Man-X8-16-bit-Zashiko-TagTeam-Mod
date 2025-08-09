extends Node

func _on_elevator_body_entered(_body: Node) -> void:
	Event.emit_signal("boss_door_open")
	GameManager.music_player.start_fade_out()
	GameManager.player.cutscene_deactivate()
	
func _on_boss_elevator_at_max() -> void:
	Event.emit_signal("boss_door_closed")
	Event.emit_signal("show_warning")
