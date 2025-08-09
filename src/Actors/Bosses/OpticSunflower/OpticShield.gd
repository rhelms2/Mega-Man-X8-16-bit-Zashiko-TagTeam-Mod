extends AttackAbility

export var optic_orb : PackedScene
onready var charge: AudioStreamPlayer2D = $charge
onready var shot: AudioStreamPlayer2D = $shot

func _Setup() -> void:
	turn_and_face_player()
	play_animation("attack3_prepare")
	charge.play()

func _Update(delta) -> void:
	process_gravity(delta)
	
	if attack_stage == 0 and has_finished_last_animation():
		play_animation("attack3_loop")
		next_attack_stage()
	
	elif attack_stage == 1 and timer > 0.5:
		play_animation("attack3_start")
		next_attack_stage()
	
	elif attack_stage == 2 and has_finished_last_animation():
		play_animation("attack3")
		shot.play()
		var o = instantiate(optic_orb)
		o.h_speed *= get_facing_direction()
		next_attack_stage()

	elif attack_stage == 3 and has_finished_last_animation():
		play_animation("attack3_end")
		next_attack_stage()
	
	elif attack_stage == 4 and has_finished_last_animation():
		EndAbility()
