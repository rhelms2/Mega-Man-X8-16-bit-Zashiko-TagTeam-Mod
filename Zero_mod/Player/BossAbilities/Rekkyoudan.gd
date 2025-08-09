extends BossAbilityZero
class_name RekkyoudanAbility


func _ready():
	if active:
		call_deferred("set_ability")

func set_ability():
	if active:
		character.saber_combo.deflectable = true
		character.saber_dash.deflectable = true
		character.saber_jump.deflectable = true
		character.saber_wall.deflectable = true
		
		character.skill_juuhazan.deflectable = true
		character.skill_rasetsusen.deflectable = true
		character.skill_raikousen.deflectable = true
		character.skill_youdantotsu.deflectable = true
		character.skill_hyouryuushou.deflectable = true
		character.skill_enkoujin.deflectable = true
		
		character.saber_combo.saber_hitbox = character.rekkyoudan_hitbox
		character.saber_dash.saber_hitbox = character.rekkyoudan_hitbox
		character.saber_jump.saber_hitbox = character.rekkyoudan_hitbox
		character.saber_wall.saber_hitbox = character.rekkyoudan_hitbox
		
		CharacterManager.set_saber_colors(animatedSprite)

func unset_ability():
	character.saber_combo.deflectable = false
	character.saber_dash.deflectable = false
	character.saber_jump.deflectable = false
	character.saber_wall.deflectable = false
	
	character.skill_juuhazan.deflectable = false
	character.skill_rasetsusen.deflectable = false
	character.skill_raikousen.deflectable = false
	character.skill_youdantotsu.deflectable = false
	character.skill_hyouryuushou.deflectable = false
	character.skill_enkoujin.deflectable = false

	character.saber_combo.saber_hitbox = character.saber_hitbox
	character.saber_dash.saber_hitbox = character.saber_hitbox
	character.saber_jump.saber_hitbox = character.saber_hitbox
	character.saber_wall.saber_hitbox = character.saber_hitbox
	
	CharacterManager.set_saber_colors(animatedSprite)

func should_unlock(collectible: String) -> bool:
	return collectible == weapon.collectible
