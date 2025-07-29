extends AttackAbility
onready var slash_1: Node2D = $slash1
onready var slash_2: Node2D = $slash2
onready var slash_1_sfx: AudioStreamPlayer2D = $slash1_sfx
onready var slash_2_sfx: AudioStreamPlayer2D = $slash2_sfx
onready var land: AudioStreamPlayer2D = $land
onready var particles: Particles2D = $"../animatedSprite/particles"

func _Setup() -> void :
	turn_and_face_player()
	slash_1.handle_direction()
	slash_2.handle_direction()
	play_animation("slashjump_prepare")

func _Update(delta: float) -> void :
	process_gravity(delta)
	
	if attack_stage == 0 and has_finished_last_animation():
		play_animation("slashjump_prepare_loop")
		next_attack_stage()
	
	elif attack_stage == 1 and timer > 0.1:
		play_animation("slashjump_start")
		force_movement(40)
		next_attack_stage()
		
	elif attack_stage == 2 and has_finished_last_animation():
		play_animation("slashjump_slash")
		slash_1.activate()
		slash_1_sfx.play_rp()
		particles.emitting = true
		force_movement(0)
		screenshake()
		next_attack_stage()
		
	elif attack_stage == 3 and has_finished_last_animation():
		play_animation("slashjump_jump")
		slash_2_sfx.play_rp()
		tween_speed(get_initial_jump_speed(), 150, 0.7)
		set_vertical_speed(get_jump_height())
		next_attack_stage()
		
	elif attack_stage == 4 and get_vertical_speed() > 150:
		play_animation("slashjump_fall")
		set_vertical_speed(350)
		slash_2.activate()
		next_attack_stage()
	
	elif attack_stage == 5:
		if has_finished_last_animation():
			play_animation_once("slashjump_fall_loop")
		if character.is_on_floor():
			play_animation_once("slashjump_land")
			screenshake()
			land.play_rp()
			kill_tweens(tween_list)
			force_movement(0)
			particles.restart()
			particles.emitting = true
			slash_2.deactivate()
			next_attack_stage()
			
	elif attack_stage == 6 and has_finished_last_animation():
		play_animation("slashjump_land_loop")
		next_attack_stage()

	elif attack_stage == 7 and timer > 0.25:
		play_animation("slashjump_end")
		next_attack_stage()
		
	elif attack_stage == 8 and has_finished_last_animation():
		EndAbility()

func _Interrupt():
	._Interrupt()
	slash_2.deactivate()

func get_initial_jump_speed() -> float:
	var h_speed = abs(get_distance_to_player())
	if abs(get_distance_to_player()) > 150:
		h_speed = h_speed * 2
	return h_speed

func get_jump_height() -> float:
	var h_speed = abs(get_total_distance_to_player())*3
	h_speed = clamp(h_speed,300,450)
	return -h_speed

func get_total_distance_to_player() -> float:
	return character.global_position.distance_to(GameManager.get_player_position())

func process_gravity(_delta: float, gravity: = default_gravity) -> void :
	character.add_vertical_speed(gravity * _delta)
