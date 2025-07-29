extends AttackAbility
onready var dash_particles: Particles2D = $dash_particles
onready var dash: AudioStreamPlayer2D = $dash

func _Setup() -> void :
	turn_and_face_player()
	dash.play()
	dash_particles.emitting = true
	tween_speed(0, horizontal_velocity / 2, 0.15)

func _Update(_delta: float) -> void :
	process_gravity(_delta)
	if attack_stage == 0 and has_finished_last_animation():
		play_animation("dash")
		force_movement(horizontal_velocity)
		next_attack_stage()
	
	elif attack_stage == 1:
		if timer > 0.55 or is_colliding_with_wall() or has_player_jumped_above():
			next_attack_stage()
	
	elif attack_stage == 2:
		play_animation("dash_end")
		decay_speed(0.5, 0.35)
		dash_particles.emitting = false
		next_attack_stage()
		
	elif attack_stage == 3 and has_finished_last_animation():
		EndAbility()

func _Interrupt() -> void :
	dash_particles.emitting = false
	._Interrupt()

func has_player_jumped_above() -> bool:
	return is_player_above() and not is_player_in_front()
