extends BeePatrol

var delay_direction := 0

func handle_turn(r_destination : Vector2) -> void:
	if r_destination.x > global_position.x:
		if character.get_direction() != 1:
			play_animation("turn")
			delay_direction = 1
		#set_direction(1)
	else:
		if character.get_direction() != -1:
			play_animation("turn")
			delay_direction = -1
		#set_direction(-1)

	

func _Update(_delta) -> void:
	if attack_stage == 0 and has_finished_animation("turn"):
		set_direction(delay_direction)
		play_animation_once("idle")
	if attack_stage == 0 and timer > travel_time:
		next_attack_stage()
