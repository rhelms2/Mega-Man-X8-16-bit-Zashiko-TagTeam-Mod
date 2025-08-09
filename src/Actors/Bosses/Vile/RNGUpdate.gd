extends Node

func _on_BossDeath_ability_start(_ability) -> void:
	BossRNG.stage_vile_defeated()
