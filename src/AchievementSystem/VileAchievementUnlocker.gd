extends Node

func _ready() -> void:
	get_parent().connect("defeated",self,"fire_achievements")

func fire_achievements():
	if defeated_both_viles():
		Achievements.unlock("VILEDEFEATEDTWICE")

func defeated_both_viles():
	return GlobalVariables.get("defeated_antonion_vile") and GlobalVariables.get("defeated_panda_vile")


