extends BossAI


func _ready() -> void:
	pass

func decide_time_for_next_attack():
	#var max_time = (character.current_health * time_between_attacks.y)/ character.max_health
	#
	timer_for_next_attack = 5.0
