extends Panda


func process_death(delta):
	Event.emit_signal("enemy_kill", self)
	queue_free()
