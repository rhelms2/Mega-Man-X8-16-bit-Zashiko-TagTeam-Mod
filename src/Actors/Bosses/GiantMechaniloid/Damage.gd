extends BossDamage


func should_ignore_damage(_t) -> bool:
	return false

func reduce_health(_i, _g) -> void :
	character.reduce_health(25 * CharacterManager.damage_deal_multiplier)
	max_flash_time = normal_flash_time
	
func damage(damage, inflicter) -> float:
	if should_be_damaged(inflicter):
		reduce_health(damage, inflicter)
		emit_combo_hit(inflicter)
		apply_invulnerability_or_death()
		play_vfx()
	return character.current_health

func should_be_damaged(inflicter) -> bool:
	return inflicter.name == "BossDamager"
