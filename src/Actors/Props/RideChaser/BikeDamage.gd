extends Damage
class_name BikeDamage

func _Setup() -> void:
	character.current_health -= damage_taken
	character.set_invulnerability(invulnerability_time)
	character.remove_invulnerability_shader()
	character.apply_damage_shader()
	Log("received damage. Health: " + str(character.current_health))
	
func _Update(_delta: float) -> void:
	pass #overriding base knockback

func _EndCondition() -> bool:
	if Has_time_ran_out():
		return true
	return false

func _Interrupt() -> void:
	character.stop_damage_shader()
	character.apply_invulnerability_shader()
	
func should_be_damaged() -> bool:
	return character.has_health()
	
func on_damage(value, _inflicter) -> void:
	if should_be_damaged():
		if not character.is_invulnerable():
			damage_taken = value
			damage_taken = value
			ExecuteOnce()
