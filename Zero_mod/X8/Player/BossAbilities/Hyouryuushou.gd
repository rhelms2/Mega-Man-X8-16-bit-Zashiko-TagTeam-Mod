extends BossAbilityZero
class_name HyouryuushouAbilityX8


func _ready():
	if active:
		call_deferred("set_ability")

func set_ability():
	if active:
		character.Hyouryuushou = true


func should_unlock(collectible: String) -> bool:
	return collectible == weapon.collectible

func _on_Forced_ability_start(_node):
	pass
	
