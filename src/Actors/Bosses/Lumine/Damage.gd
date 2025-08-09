extends BossDamage

const exceptions = ["RideArmor","Optic","Fire"]
onready var panda: Node2D = $"../Panda"

func should_ignore_damage (inflicter) -> bool:
	if panda.executing and panda.attack_stage >= 4:
		if character.is_invulnerable() or not character.has_health():
			return true
			
		if only_on_screen and not GameManager.is_on_screen(character.global_position):
			return true
			
		if inflicter.global_position.y > global_position.y + 17:
			for word in exceptions:
				if word in inflicter.name:
					return false
			return true

		if ignore_nearby_hits and character.has_shield():
			if "bypass_shield" in inflicter:
				return false
			if character.get_direction() > 0 and inflicter.get_facing_direction() < 0:
				return true
			elif character.get_direction() < 0 and inflicter.get_facing_direction() > 0:
				return true
		return false
	else:
		return .should_ignore_damage(inflicter)

func set_damage_reduction (_value):
	pass
	#discarding damage reduction for Lumine
	
func handle_weakness(inflicter) -> float:
	var dmg_value = 0.0
	dmg_value = inflicter.damage_to_weakness 
	character.reduce_health(dmg_value)
	if "Charged" in inflicter.name or "Punch" in inflicter.name:
		print_debug("Hit by charged weakness for " + str(dmg_value))
		invulnerability_time = charged_weakness_invul_time
		emit_signal("charged_weakness_hit",get_inflicter_direction(inflicter))
	else:
		print_debug("Hit by weakness for " + str(dmg_value))
		invulnerability_time = weakness_invulnerability_time
	max_flash_time = invulnerability_time
	return dmg_value
