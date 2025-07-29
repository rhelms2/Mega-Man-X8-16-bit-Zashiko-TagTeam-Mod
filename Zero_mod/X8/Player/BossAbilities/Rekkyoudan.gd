extends BossAbilityZero
class_name RekkyoudanAbilityX8

func _ready() -> void :
	if active:
		call_deferred("set_ability")

func set_ability() -> void :
	if active:
		for node in character.attack_nodes:
			node.deflectable = true
			for weapon in character.zero_weapons:
				if node.name.begins_with(weapon):
					node.saber_hitbox = character.rekkyoudan_hitbox
		
		CharacterManager.set_saberX8_colors(animatedSprite)

func unset_ability() -> void :
	for node in character.attack_nodes:
		node.deflectable = false
		for weapon in character.zero_weapons:
			if node.name.begins_with(weapon):
				node.saber_hitbox = character.saber_hitbox
	
	CharacterManager.set_saberX8_colors(animatedSprite)

func should_unlock(collectible: String) -> bool:
	return collectible == weapon.collectible
