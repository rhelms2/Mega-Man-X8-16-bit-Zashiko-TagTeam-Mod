extends BossAbilityZero
class_name YoudantotsuAbilityX8


func _ready():
	if active:
		call_deferred("set_ability")

func set_ability():
	if active:
		character.Youdantotsu = true


func should_unlock(collectible: String) -> bool:
	return collectible == weapon.collectible
