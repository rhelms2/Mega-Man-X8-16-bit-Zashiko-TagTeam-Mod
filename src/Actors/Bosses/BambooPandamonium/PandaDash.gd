extends AttackAbility
var barriers_present:= false
onready var dash: AudioStreamPlayer2D = $dash

func _on_barriers_created() -> void:
	barriers_present = true
func _on_barriers_destroyed() -> void:
	barriers_present = false

func _Setup() -> void:
	if not barriers_present:
		EndAbility()
	else:
		play_animation("dash_prepare")

func _Update(_delta) -> void:
	process_gravity(_delta)
	if attack_stage == 0 and has_finished_last_animation():
		play_animation("dash_loop")
		dash.play()
		force_movement(horizontal_velocity)
		next_attack_stage()
		
	elif attack_stage == 1 and timer > 0.75:
		play_animation("dash_end")
		decay_speed(0.5,0.35)
		next_attack_stage()
		
	elif attack_stage == 2 and has_finished_last_animation():
		turn()
		play_animation_once("idle")
		next_attack_stage()
		
	elif attack_stage == 3:
		EndAbility()

