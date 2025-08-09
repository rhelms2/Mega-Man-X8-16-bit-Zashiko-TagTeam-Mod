extends AttackAbility
class_name IceJump

export(PackedScene) var small_snow_wave
export(PackedScene) var quake
export var horizontal_speed := 420.0
export var jump_speed := 440.0
onready var land_particles = $"Land"
onready var jump_particle = $Jump
onready var jump = $jump
onready var land = $land
onready var quake_prepare = $quake_prepare
onready var quake_sfx = $quake

func get_horizontal_velocity() -> float:
	return horizontal_speed

func get_jump_velocity() -> float:
	return jump_speed

func _Update(delta):
	if attack_stage == 0 and has_finished_last_animation():
		set_vertical_speed(-get_jump_velocity())
		play_animation_once("icejump_up")
		toggle_emit(jump_particle, true)
		screenshake()
		jump.play()
		force_movement(get_horizontal_velocity() * abs(get_distance_to_player()) / 200)
		reset_decay(abs(character.get_horizontal_speed()))
		if timer > 0.048:
			next_attack_stage_on_next_frame()
			
	elif attack_stage == 1:
		process_gravity(delta)
		decay_horizontal_speed(1.5, delta)
		if timer > 0.25:
			if character.get_vertical_speed() > 0:
				play_animation_once("icejump_fall")
				next_attack_stage_on_next_frame()
	
	elif attack_stage == 2:
		process_gravity(delta)
		decay_horizontal_speed(1.5, delta)
		if character.is_on_floor():
			force_movement(0)
			next_attack_stage_on_next_frame()
			
	elif attack_stage == 3:
		play_animation_once("icejump_land")
		toggle_emit(land_particles, true)
		land.play()
		snow_waves()
		next_attack_stage_on_next_frame()
		
	elif attack_stage == 4 and has_finished_last_animation():
		play_animation_once("icejump_quake_prepare")
		quake_prepare.play()
		if has_finished_last_animation():
			next_attack_stage_on_next_frame()
	
	elif attack_stage == 5:
		play_animation_once("icejump_quake")
		earthquake()
		quake_sfx.play()
		next_attack_stage_on_next_frame()
			
	elif attack_stage == 6 and has_finished_last_animation():
		EndAbility()

func _Interrupt():
	._Interrupt()
	play_animation_once("icejump_end")
	Event.emit_signal("screenshake", 2)

func snow_waves():
	screenshake()
	fire(small_snow_wave, Vector2(0, 48), 1)
	fire(small_snow_wave, Vector2(0, 48), -1)

func earthquake():
	screenshake()
	fire(quake, Vector2(0, 48), 1)
	fire(quake, Vector2(0, 48), -1)
	
