extends BossAbilityZero
class_name JuuhazanAbility


func _ready() -> void :
	if active:
		call_deferred("set_ability")

func set_ability() -> void :
	if active:
		character.Juuhazan = true

func should_unlock(collectible: String) -> bool:
	return collectible == weapon.collectible
