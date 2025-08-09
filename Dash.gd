extends Movement
class_name Dash

export var dash_duration := 0.55
export var upgraded := false
export var invulnerability_duration := 0.0
export var leeway := 0.1
onready var particles = character.get_node("animatedSprite").get_node("Dash Smoke Particles")
onready var dash_particle = get_node("dash_particle")
var ghost_particle
var sprite_effect
var _dash
var emitted_dash  := false
var left_ground_timer := 0.0
var can_dash := true

export var shot_pos_adjust := Vector2 (18,4)
func get_shot_adust_position() -> Vector2:
	return shot_pos_adjust

func _ready() -> void:
	sprite_effect = get_node("duringImage")
	ghost_particle = get_node("particles2D")
	
func get_activation_leeway_time() -> float:
	return leeway

func _Setup() -> void:
	Event.emit_signal("dash")
	set_direction(get_pressed_direction())
	update_bonus_horizontal_only_conveyor()
	emit_particles(particles, true)
	character.reduce_hitbox()
	invulnerable(true)
	emitted_dash = false
	changed_animation = false
	left_ground_timer = 0
	can_dash = true
	deactivate_low_jumpcasts()
	jumpcast_timer = 0


func emit_dash_particle():
	if not emitted_dash:
		if get_pressed_direction() != 0:
			_dash = dash_particle.emit(get_pressed_direction())
		else:
			_dash = dash_particle.emit(character.get_facing_direction())
		emitted_dash = true

func _Update(_delta: float) -> void:
	process_invulnerability()
	increase_left_ground_timer(_delta)
	if can_dash and should_dash():
		on_dash()
		force_movement(horizontal_velocity)
		emit_dash_particle()
		if not character.is_on_floor():
			character.set_vertical_speed(0)
	else:
		can_dash = false
		if left_ground_timer == 0.0: #not left_ground:
			left_ground_timer = 0.01
			character.set_vertical_speed(0)
			invulnerable(false)
		change_animation_if_falling("fall")
		set_movement_and_direction(horizontal_velocity)
		process_gravity(_delta)

func increase_left_ground_timer(_delta: float) -> void:
	if left_ground_timer > 0.0:
		left_ground_timer += _delta


func process_gravity(delta:float, gravity := default_gravity, _s = "null") -> void:
	.process_gravity(delta,gravity)
	activate_low_jumpcasts_after_delay(delta)

func on_dash() -> void: #override
	pass

func synchronize_sprite_effect():
	if invulnerability_duration > 0:
		sprite_effect.frames = character.animatedSprite.frames
		sprite_effect.frame = character.animatedSprite.frame
		sprite_effect.set_scale(Vector2(character.get_facing_direction(), 1))
		ghost_particle.set_scale(Vector2(character.get_facing_direction(), 1))
	

func change_animation_if_falling(_s) -> void:
	EndAbility()
	character.start_dashfall()

func _Interrupt():
	if not changed_animation:
		character.call_deferred("increase_hitbox")
	emit_particles(particles,false)
	invulnerable(false)
	._Interrupt()

func invulnerable(state : bool):
	if upgraded and invulnerability_duration > 0:
		if state:
			character.add_invulnerability(name)
		else:
			character.remove_invulnerability(name)
		sprite_effect.visible = state
		ghost_particle.emitting = state


func process_invulnerability():
	if upgraded and invulnerability_duration > 0:
		synchronize_sprite_effect()
		if timer > invulnerability_duration:
			invulnerable (false)

func should_dash() -> bool:
	return character.is_on_floor()

func _StartCondition() -> bool:
	if facing_a_wall():
		return false
	if should_dash():
		return true
	return false

func _EndCondition() -> bool:
	if facing_a_wall():
		return true
	
	if character.is_on_floor():
		if left_ground_timer > 0.1:
			on_touch_floor()
			return true
		if not Is_Input_Happening():
			return true
		elif Has_time_ran_out():
			return true
		elif character.facing_right and character.has_just_pressed_left():
			last_time_pressed = 0.0
			return true
		elif not character.facing_right and character.has_just_pressed_right():
			last_time_pressed = 0.0
			return true
	
	return false

func Has_time_ran_out() -> bool:
	return dash_duration < timer

func stop_particles():
	particles.visible = false
