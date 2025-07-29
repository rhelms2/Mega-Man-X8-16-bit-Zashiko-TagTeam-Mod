extends TractorAttackIdle


func _Update(delta: float) -> void :
	process_gravity(delta)
	force_movement(horizontal_velocity)

func check_for_event_errors() -> void :
	return
