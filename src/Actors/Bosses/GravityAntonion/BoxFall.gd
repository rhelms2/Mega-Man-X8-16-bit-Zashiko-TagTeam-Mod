extends AttackAbility

func _Setup() -> void:
	play_animation("ready")

func _Update(delta) -> void:
	process_gravity(delta)
	if attack_stage == 0 and has_finished_last_animation():
		play_animation("idle")
		next_attack_stage()
	
	if character.global_position.y > character.floor_position:
		character.current_health = 0

func _Interrupt() -> void:
	set_vertical_speed(0)
