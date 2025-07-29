extends Ability

func _StartCondition() -> bool:
	if abs(character.get_actual_speed()) < 200:
		return false
		
	return character.is_colliding_with_wall() == character.get_facing_direction()

func _Setup() -> void:
# warning-ignore:return_value_discarded
	character.damage(calculate_damage(),get_parent())

func calculate_damage() -> float:
	#if character.is_executing("HyperDash"):
		#Log("Hyperdash crash")
		#return abs(character.get_actual_speed()/25)
	return abs(character.get_actual_speed()/100)
	
