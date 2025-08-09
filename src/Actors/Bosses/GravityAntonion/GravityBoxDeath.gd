extends EnemyDeath



func extra_actions_at_death_start() -> void :
	Event.emit_signal("screenshake", 1.2)
	pass
