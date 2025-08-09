extends Node

func _on_BossDeath_ability_start(ability) -> void:
	GlobalVariables.set("vile_palace_defeated","defeated")
