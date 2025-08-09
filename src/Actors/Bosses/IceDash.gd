extends AttackAbility
class_name IceDash

export var horizontal_speed := 400.0
export var jump_speed := 400.0

onready var dash = $dash
onready var uppercut = $uppercut
onready var land = $land

onready var particles = [$"Snow Jet", $"Snow Jet 2"]
onready var land_particle = $Land
onready var jump_particle = $Jump

func get_horizontal_velocity() -> float:
	return horizontal_speed

func get_jump_velocity() -> float:
	return jump_speed

func _Update(delta):
	if attack_stage == 0 and timer > 0.5:
		flip(particles, character.get_facing_direction())
		dash.play()
		next_attack_stage_on_next_frame()
		
	elif attack_stage == 1 and has_finished_last_animation():
		play_animation_once("icedash_loop")
		toggle_emit(particles, true)
		next_attack_stage_on_next_frame()

	elif attack_stage == 2:
		force_movement(get_horizontal_velocity() * timer * 2)
		if is_player_nearby_horizontally(32):
			Log("Reached Player!")
			next_attack_stage_on_next_frame()
		if is_colliding_with_wall():
			Log("Found a Wall!")
			next_attack_stage_on_next_frame()
	
	elif attack_stage == 3:
		decay_horizontal_speed(7, delta)
		if abs(character.get_actual_horizontal_speed()) < 100:
			toggle_emit(jump_particle, true)
			uppercut.play()
			next_attack_stage_on_next_frame()
	
	elif attack_stage == 4:
		set_vertical_speed(-get_jump_velocity())
		toggle_emit(particles, false)
		play_animation_once("icedash_uppercut")
		if timer > 0.048:
			next_attack_stage_on_next_frame()

	elif attack_stage == 5:
		process_gravity(delta)
		decay_horizontal_speed(10, delta)
		if timer > 0.25:
			if character.get_vertical_speed() > 0:
				play_animation_once("icedash_fall")
				next_attack_stage_on_next_frame()
	
	elif attack_stage == 6:
		process_gravity(delta)
		if character.is_on_floor():
			toggle_emit(land_particle, true)
			EndAbility()

func _Interrupt():
	play_animation_once("icedash_land")
	land.play()
	toggle_emit(particles, false)
	Event.emit_signal("screenshake", 2)
