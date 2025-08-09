extends Enemy


func update_facing_direction() -> void:
	pass


func interrupt_all_moves():
	for move in executing_moves:
		move.EndAbility()
