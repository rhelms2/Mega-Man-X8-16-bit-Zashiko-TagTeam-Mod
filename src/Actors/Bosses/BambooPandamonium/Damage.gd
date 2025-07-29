extends BossDamage

const exceptions = ["RideArmor", "Optic", "Fire", "Flame", "Enkoujin", "Juuhazan", "Enkoujin_Charged", "Enkoujin_Charged_B"]

func should_ignore_damage(inflicter) -> bool:
		
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
