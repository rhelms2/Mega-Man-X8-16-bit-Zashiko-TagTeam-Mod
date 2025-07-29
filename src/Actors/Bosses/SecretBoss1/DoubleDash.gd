extends AttackAbility

onready var downslash: Node2D = $downslash
onready var highslash: Node2D = $highslash
onready var smoke_dash: Particles2D = $"../animatedSprite/smoke_dash"

onready var dash: AudioStreamPlayer2D = $dash
onready var cut_1: AudioStreamPlayer2D = $cut1
onready var cut_2: AudioStreamPlayer2D = $cut2
onready var land: AudioStreamPlayer2D = $land




func _Setup() -> void :
	turn_and_face_player()
	play_animation("dash_prepare")
	downslash.handle_direction()
	highslash.handle_direction()

func _Update(delta: float) -> void :
	process_gravity(delta)
	if attack_stage == 0 and timer > 0.5:
		play_animation("dash1")
		dash.play()
		screenshake(0.7)
		smoke_dash.emitting = true
		force_movement(550)
		next_attack_stage()
	
	elif attack_stage == 1 and timer > 0.1:
		if is_player_nearby_horizontally(64.0) or timer > 1 or facing_a_wall():
			if is_player_nearby_vertically(48):
				play_animation("dash1_slash")
				cut_2.play()
				downslash.activate()
				force_movement(-200)
				#call_deferred("decay_speed",1,.85)
				set_vertical_speed(-200)
				smoke_dash.emitting = false
				next_attack_stage()
			else:
				rising_slash()
				go_to_attack_stage(5)
	
	elif attack_stage == 2 and timer > 0.1:
		if character.is_on_floor():
			kill_tweens(tween_list)
			decay_speed(1, 0.15)
			play_animation("dash_land")
			land.play()
			next_attack_stage()
	
	elif attack_stage == 3 and timer > 0.16:
			kill_tweens(tween_list)
			play_animation("dash2")
			dash.play()
			smoke_dash.emitting = true
			force_movement(550)
			next_attack_stage()
		
	
	elif attack_stage == 4 and timer > 0.25:
		if timer > 0.25 or facing_a_wall():
			rising_slash()
			next_attack_stage()

	elif attack_stage == 5 and timer > 0.1:
		if character.is_on_floor():
			play_animation("dash_land")
			land.play()
			screenshake(0.7)
			force_movement(0)
			next_attack_stage()
			
	elif attack_stage == 6 and has_finished_last_animation():
		EndAbility()

func _Interrupt() -> void:
	._Interrupt()
	smoke_dash.emitting = false

func rising_slash():
	highslash.activate()
	play_animation("dash2_slash")
	force_movement(200)
	set_vertical_speed(-450)
	call_deferred("decay_speed",1,1.25)
	cut_1.play()
	smoke_dash.emitting = false
	
