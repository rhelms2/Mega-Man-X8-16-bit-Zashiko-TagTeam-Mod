extends MultipleShot

export var point_time := 1.0
export var charge_time := 1.0

func _Update(_delta) -> void:
	if attack_stage == 0:#
		if turning:
			if has_finished_last_animation():
				set_direction(get_player_direction_relative())
				play_animation(animation)
				turning = false
				next_attack_stage()
		else:
			next_attack_stage()
	
	elif attack_stage == 1 and has_finished_last_animation():
		play_animation_once("armed_loop")
		if timer > point_time:
			next_attack_stage()
	
	elif attack_stage == 2:
		play_animation_once("prepare")
		if timer > charge_time:
			next_attack_stage()

	elif attack_stage == 3:
		play_animation_once(shot_animation)
		actual_fire_pos = get_node(shot_position).global_position
		fire(projectile, actual_fire_pos)
		shot_sound.play()
		next_attack_stage()
		
	elif attack_stage == 4 and has_finished_last_animation():
		play_animation_once("armed_loop")
		if timer > shot_duration:
			play_animation(recover_animation)
			next_attack_stage()
	
	elif attack_stage == 5 and has_finished_last_animation():
		play_animation_once("idle")
		if timer > 1.0:
			EndAbility()
