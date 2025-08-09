extends AttackAbility

func _Setup():
# warning-ignore:narrowing_conversion
	set_direction(get_facing_direction() * -1.0, true)
	#print(character.get_direction())
	
func _EndCondition() -> bool:
	return true
