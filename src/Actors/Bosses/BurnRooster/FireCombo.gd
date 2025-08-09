extends AttackAbility
export (PackedScene) var projectile
export (PackedScene) var fast_projectile
var impulse := 60.0
onready var highkick: Node2D = $highkick
onready var lowkick: Node2D = $lowkick
onready var phoenix_cry: AudioStreamPlayer2D = $phoenix
onready var low_snd: AudioStreamPlayer2D = $lowkick2
onready var high_snd: AudioStreamPlayer2D = $highkick2
onready var round_snd: AudioStreamPlayer2D = $roundkick
onready var land: AudioStreamPlayer2D = $land
onready var fire_2: Particles2D = $fire_particles/fire2
onready var fire_3: Particles2D = $fire_particles/fire3
onready var fire_1: Particles2D = $fire_particles/fire1
onready var fire_particles: Node2D = $fire_particles

func emit_fire() -> void:
	fire_particles.scale.x = character.get_facing_direction()
	fire_1.emitting = true
	fire_2.emitting = true
	fire_3.emitting = true

func _Update(delta) -> void:
	process_gravity(delta)
	if attack_stage == 0:
		tween_speed(relative_to_player_distance(impulse,300), impulse/6, 0.35)
		next_attack_stage()
	
	if attack_stage == 1 and timer > 0.35:
		play_animation_once("lowkick")
		lowkick.activate()
		low_snd.play()
		call_deferred("fire_projectile")
		force_movement(relative_to_player_distance(horizontal_velocity,400))
		call_deferred("decay_speed",1,0.3)
		next_attack_stage()

	elif attack_stage == 2 and has_finished_last_animation():
		turn_and_face_player()
		play_animation_once("highkick_prepare")
		force_movement(relative_to_player_distance(horizontal_velocity,160))
		set_vertical_speed(-jump_velocity/1.25)
		call_deferred("decay_speed",1,0.65)
		next_attack_stage()

	elif attack_stage == 3 and has_finished_last_animation():
		play_animation_once("highkick")
		emit_fire()
		highkick.activate()
		high_snd.play()
		next_attack_stage()

	elif attack_stage == 4 and character.is_on_floor():
		if is_player_above(64) and is_player_nearby_horizontally(64):
			play_animation_once("roundhouse_prepare")
			decay_speed()
			next_attack_stage()
		else:
			go_to_attack_stage_on_next_frame(8)
		
	elif attack_stage == 5 and has_finished_last_animation():
		play_animation_once("roundhouse")
		instantiate_projectile(projectile)# warning-ignore:return_value_discarded
		phoenix_cry.play()
		round_snd.play()
		tween_speed(relative_to_player_distance(-impulse*2), 0, 0.75)
		set_vertical_speed(-jump_velocity)
		next_attack_stage()
	
	elif attack_stage == 6:
		if character.is_on_floor():
			go_to_attack_stage(8)
		elif has_finished_last_animation():
			play_animation_once("jump_backwards")
			next_attack_stage()

	elif attack_stage ==7 and character.is_on_floor():
		next_attack_stage()

	elif attack_stage == 8:
		play_animation_once("land")
		land.play()
		next_attack_stage_on_next_frame()
	
	elif attack_stage == 9 and has_finished_last_animation():
		EndAbility()

func _Interrupt() -> void:
	kill_tweens(tween_list)
	play_animation_once("idle")

func relative_to_player_distance(speed, multiplier := 150.0) -> float:
	return speed * abs(get_distance_to_player()/multiplier)

func turn_and_face_player() -> void:
	.turn_and_face_player()
	highkick.handle_direction()
	lowkick.handle_direction()

func fire_projectile() -> void:
	var shot = instantiate_projectile(fast_projectile)
	shot.global_position = global_position
	shot.global_position.y += 32
	shot.global_position.x += 64 * character.get_facing_direction()
	shot.set_horizontal_speed(800 * character.get_facing_direction())
