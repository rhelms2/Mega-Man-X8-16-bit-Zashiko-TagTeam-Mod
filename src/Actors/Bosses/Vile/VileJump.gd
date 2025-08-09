extends AttackAbility

export var projectile : PackedScene
const knee_time := 0.3
onready var land_particles: Particles2D = $land_particles
onready var land: AudioStreamPlayer2D = $land
onready var shot_sound: AudioStreamPlayer2D = $shot_sound
onready var jump: AudioStreamPlayer2D = $jump

func _Update(_delta) -> void:
	if attack_stage == 0 and has_finished_last_animation():
		jump.play()
		play_animation("jump_start")
		force_movement(horizontal_velocity)
		set_vertical_speed(-jump_velocity)
		next_attack_stage()
	
	elif attack_stage == 1:
		process_gravity(_delta)
		if has_finished_last_animation():
			play_animation_once("jump")
		
		if is_falling() and not is_player_above() and timer < 0.55:
			play_animation("jump_stop")
			decay_speed(0.5,0.27)
			next_attack_stage()
		
		if_on_floor_go_to_land()
	
	elif attack_stage == 2:
		fire_projectile()
	
	elif attack_stage == 3 and timer > knee_time: #return movement
		play_animation("kneel_end")
		tween_speed(0,horizontal_velocity,0.15)
		next_attack_stage()
	
	elif attack_stage == 4:
		process_gravity(_delta)
		if has_finished_last_animation():
			play_animation_once("jump")
		if_on_floor_go_to_land()
		
	elif attack_stage == 5:
		play_animation("jump_land")
		decay_speed(0.5,0.35)
		land.play()
		next_attack_stage()
		land_particles.emitting = true
		
	elif attack_stage == 6:
		if timer > 0.25 and land_particles.emitting:
			land_particles.emitting = false
		if has_finished_last_animation():
			EndAbility()

func _Interrupt() -> void:
	._Interrupt()
	land_particles.emitting = false

func is_falling() -> bool:
	return get_vertical_speed() > 0

func if_on_floor_go_to_land() -> void:
	if timer > 0.1 and character.is_on_floor():
		go_to_attack_stage(5)

func fire_projectile() -> void:
	if has_finished_last_animation():
		set_vertical_speed(0)
		play_animation_again("kneel_shot")
		var shot = instantiate(projectile) 
		shot.set_creator(self)
		shot.initialize(-get_player_direction_relative())
		shot.set_vertical_speed(300)
		shot_sound.play()
		next_attack_stage()
