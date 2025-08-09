extends AttackAbility
onready var fire_1: Particles2D = $fire1
onready var fire_2: Particles2D = $fire2
onready var fire_3: Particles2D = $fire3
onready var knee: AudioStreamPlayer2D = $knee
onready var charge: AudioStreamPlayer2D = $charge
onready var land: AudioStreamPlayer2D = $land

func _Setup() -> void:
	._Setup()
	charge.play()

func _Update(_delta) -> void:
	process_gravity(_delta)
	if attack_stage == 0 and has_finished_last_animation():
		play_animation("knee_prepare_loop")
		emit_fire()
		next_attack_stage()
	
	elif attack_stage == 1 and timer > 0.55:
		next_attack_stage()
	
	elif attack_stage == 2:
		play_animation("knee")
		knee.play()
		force_movement(horizontal_velocity)
		set_vertical_speed(- jump_velocity)
		next_attack_stage()
	
	elif attack_stage == 3 and has_finished_last_animation():
		play_animation("knee_loop")
		next_attack_stage()
	
	elif attack_stage == 4 and character.is_on_floor():
		play_animation_once("knee_end")
		land.play()
		stop_fire()
		decay_speed(0.5,0.4)
		next_attack_stage()
		
	elif attack_stage == 5 and timer > 0.4:
		EndAbility()

func _Interrupt() -> void:
	._Interrupt()
	stop_fire()
	kill_tweens(tween_list)

func emit_fire() -> void:
	fire_1.emitting = true
	fire_2.emitting = true
	fire_3.emitting = true

func stop_fire() -> void:
	fire_1.emitting = false
	fire_2.emitting = false
	fire_3.emitting = false
