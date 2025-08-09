extends BossAI

const bamboo_attack: int = 0
const dash_attack: int = 2

func randomize_remaining_attack_slots() -> void :
	while order_of_attacks.size() < order_size:
		var next_attack_candidate = roll_attack()
		if next_attack_candidate == dash_attack:
			next_attack_candidate = bamboo_attack
		if get_last_attack_added() == bamboo_attack:
			if is_not_bamboo_or_dash(next_attack_candidate):
				order_of_attacks.append(dash_attack)
		if next_attack_candidate == get_last_two_attacks_added():
			next_attack_candidate = (reroll_attack(next_attack_candidate))
		order_of_attacks.append(next_attack_candidate)

func get_last_attack_added() -> int:
	return order_of_attacks[order_of_attacks.size() - 1]

func is_not_bamboo_or_dash(next_attack) -> bool:
	return next_attack != bamboo_attack and next_attack != dash_attack
