extends BossAI

var time_multiplier: float = 0.0


func _ready() -> void :
	pass

func guarantee_all_attacks_on_start():
	var set_boss_order = GameManager.lumine_boss_order
	if set_boss_order and set_boss_order.size() == 8:
		order_of_attacks = set_boss_order
	else:
		order_of_attacks = [0, 1, 2, 3, 4, 5, 6, 7]

func randomize_remaining_attack_slots():
	pass

func decide_time_for_next_attack():
	time_multiplier += 0.8
	time_multiplier = clamp(time_multiplier, 0, 7)
	timer_for_next_attack = 5 + time_multiplier
