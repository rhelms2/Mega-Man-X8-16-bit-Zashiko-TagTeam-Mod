extends AttackAbility

const original_velocity := 120.0
var duration := 0.5
var tween

func _Setup() -> void:
	tween = create_tween()
	tween.tween_method(self,"force_movement",get_actual_speed(),horizontal_velocity/1.25,duration/2) # warning-ignore:return_value_discarded 
	
func _Update(_delta) -> void:
	process_gravity(_delta)
	update_values()
	if attack_stage == 0 and timer > 0.5:
		tween = create_tween()
		tween.tween_method(self,"force_movement",get_actual_speed(),horizontal_velocity,duration) # warning-ignore:return_value_discarded 
		play_animation("wheelie_start")
		next_attack_stage()
	
	if attack_stage == 1 and has_finished_last_animation():
		play_animation("wheelie_loop")
		next_attack_stage()

	elif attack_stage == 2:
		if timer > duration or is_player_is_behind():
			play_animation_once("wheelie_end")
			tween = create_tween()
			tween.tween_method(self,"force_movement",get_actual_speed(),horizontal_velocity,duration) # warning-ignore:return_value_discarded 
			next_attack_stage()

	elif attack_stage == 3 and has_finished_last_animation():
		EndAbility()

func update_values() -> void:
	if GameManager.player and GameManager.player.ride:
		duration = 1.5
		horizontal_velocity = 420
	else:
		duration = 0.5
		horizontal_velocity = 280

func is_player_is_behind() -> bool:
	return character.get_facing_direction() != get_player_direction_relative()

func _Interrupt() -> void:
	if tween:
		tween.kill()
	play_animation("idle")

func _StartCondition() -> bool:
	return GameManager.is_on_camera(character)
