extends AttackAbility
class_name IceStomp

export(PackedScene) var snow_wave
export var horizontal_speed := 420.0
onready var stomp = $stomp
onready var land_particles = $"Land"
var deacceleration := 10

func _Update(delta):
	if attack_stage == 0:
		if not has_finished_last_animation():
			if timer > 0.33:
				decay_horizontal_speed(deacceleration, delta)
		else:
			force_movement(0)
			play_animation_once("icestomp")
			toggle_emit(land_particles, true)
			stomp.play()
			fire(snow_wave, Vector2(0, 48))
			next_attack_stage_on_next_frame()
			screenshake()

	elif attack_stage == 1 and has_finished_last_animation():
		play_animation_once("icestomp_p2_prepare")
		turn_and_face_player()
		next_attack_stage_on_next_frame()
		reset_decay()
	
	elif attack_stage == 2:
		if not has_finished_last_animation():
			decay_horizontal_speed(deacceleration, delta)
		else:
			force_movement(0)
			play_animation_once("icestomp_p2")
			restart(land_particles)
			toggle_emit(land_particles, true)
			stomp.play()
			fire(snow_wave, Vector2(0, 48))
			next_attack_stage_on_next_frame()
			screenshake()

	elif attack_stage == 3 and has_finished_last_animation():
		EndAbility()
	
func _Interrupt():
	play_animation_once("icestomp_end")

func get_horizontal_velocity() -> float:
	return horizontal_speed
