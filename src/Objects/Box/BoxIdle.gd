extends AttackAbility
export  var gravity: = false

func _Setup() -> void :
	pass

func _Update(delta: float) -> void :
	if gravity:
		process_gravity(delta)

func check_for_event_errors() -> void :
	pass

