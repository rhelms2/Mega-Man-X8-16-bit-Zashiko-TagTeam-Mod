extends AttackAbility

func _Update(delta) -> void:
	process_gravity(delta)
	if attack_stage == 0 and timer > 2:
		turn()
		next_attack_stage_on_next_frame()
	
	elif attack_stage == 1:
		play_animation("walk")
		force_movement(60.0)
		next_attack_stage()
	
	elif attack_stage == 2 and timer > 0.5:
		force_movement(0)
		play_animation("idle")
		go_to_attack_stage(0)

func _Interrupt() -> void:
	force_movement(0)
