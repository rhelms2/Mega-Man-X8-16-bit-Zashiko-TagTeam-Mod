extends BossAI

func randomize_remaining_attack_slots():
	while order_of_attacks.size() < order_size:
		var next_attack_candidate = roll_attack()
		if next_attack_candidate == get_last_two_attacks_added():
			next_attack_candidate = (reroll_attack(next_attack_candidate))
		order_of_attacks.append(next_attack_candidate)
		order_of_attacks.append(3)
