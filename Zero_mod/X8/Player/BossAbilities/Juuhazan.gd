extends BossAbilityZero
class_name JuuhazanAbilityX8


func _ready():
	if active:
		call_deferred("set_ability")

func set_ability():
	if active:
		character.Juuhazan = true


func should_unlock(collectible: String) -> bool:
	return collectible == weapon.collectible
