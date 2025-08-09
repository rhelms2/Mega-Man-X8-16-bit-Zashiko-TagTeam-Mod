extends AttackAbility

const original_velocity := 120.0
const duration := 0.75

var tween : SceneTreeTween

func _Setup() -> void:
	tween = create_tween()
	tween.tween_method(self,"force_movement",get_actual_speed(),0.0,duration) # warning-ignore:return_value_discarded 

func _Update(_delta) -> void:
	process_gravity(_delta)
	if attack_stage == 0 and timer > duration:
		turn()
		play_animation("turn")
		tween = create_tween()
		tween.tween_method(self,"force_movement",0.0,original_velocity,duration) # warning-ignore:return_value_discarded 
		next_attack_stage()

	elif attack_stage == 1 and timer > duration:
		EndAbility()
		
func _Interrupt() -> void:
	if tween:
		tween.kill()
	play_animation("idle")
	force_movement(original_velocity)
