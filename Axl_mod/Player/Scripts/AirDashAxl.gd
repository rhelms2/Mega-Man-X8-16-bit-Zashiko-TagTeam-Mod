extends DashAxl
class_name AirDashAxl

onready var animatedSprite: AnimatedSprite = character.get_node("animatedSprite")
onready var hover: Node2D = character.get_node("Hover")
onready var wall_jump: Node2D = $"../WallJump"
onready var dash_wall_jump: Node2D = $"../DashWallJump"

var should_reduce_airjumps: bool = false
var infinite_airdashes: bool = false
var max_airdashes: int = 1
var airdash_count: int = 1
var initial_direction: int = 1
var initial_sound: bool = true
var facing_direction: int = 1
var rotation_value: int = 90
var go_upwards: bool = false
var initial_duration: float


func _ready() -> void :
	character.listen("land", self, "reset_airdash_count")
	character.listen("wallslide", self, "reset_airdash_count")
	character.listen("walljump", self, "reset_airdash_count")
	character.listen("dashjump", self, "reduce_airdash_count")
	character.listen("firedash", self, "reduce_airdash_count")
	character.listen("headbump", self, "on_headbump")

func _Setup() -> void :
	._Setup()
	character.set_vertical_speed(0)
	reduce_air_jumps()
	airdash_count -= 1
	left_ground_timer = 0.0
	initial_direction = character.get_facing_direction()
	character.activate_low_walljump_raycasts()
	Event.emit_signal("airdash")
	character.airdash_signal()
	$label.text = str(airdash_count)
	go_upwards = false
	initial_duration = dash_duration
	if upgraded:
		if character.facing_right:
			facing_direction = 1
		else:
			facing_direction = - 1
		if execute_dash_up():
			dash_duration = 0.3
			rotation_value = - 90 * facing_direction
			dash_particle.rotation_degrees = rotation_value
			dash_particle.position = Vector2( - 4, 16)
			animatedSprite.frame = 1
			animatedSprite.rotation_degrees = rotation_value
			animatedSprite.position.x = - 10 * facing_direction
			go_upwards = true

func _Update(_delta: float) -> void :
	process_invulnerability()
	increase_left_ground_timer(_delta)
	if can_dash and should_dash() and not go_upwards:
		on_dash()
		force_movement(horizontal_velocity)
		emit_dash_particle()
		if not character.is_on_floor():
			character.set_vertical_speed(0)
	elif can_dash and should_dash_up() and go_upwards:
		on_dash()
		force_movement(0)
		emit_dash_particle()
		character.set_vertical_speed( - horizontal_velocity)
		animatedSprite.rotation_degrees = rotation_value
		animatedSprite.position.x = - 10 * facing_direction
	else:
		if go_upwards:
			animatedSprite.frame = 0
		can_dash = false
		if left_ground_timer == 0.0:
			left_ground_timer = 0.01
			invulnerable(false)
		change_animation_if_falling("fall")
		set_movement_and_direction(horizontal_velocity)
		process_gravity(_delta)

func reset_airdash_count() -> void :
	airdash_count = max_airdashes
	$label.text = str(airdash_count)
	
func reduce_airdash_count() -> void :
	airdash_count -= 1
	$label.text = str(airdash_count)

func should_dash() -> bool:
	if not has_let_go_of_input:
		if not character.is_on_floor():
			if not Has_time_ran_out():
				if not facing_a_wall():
					return true
	return false

func should_dash_up() -> bool:
	if not has_let_go_of_input:
		if not character.is_on_floor():
			if not Has_time_ran_out():
				return true
	return false

func on_headbump() -> void :
	if executing:
		if go_upwards:
			character.set_vertical_speed(0)
			EndAbility()

func execute_dash_up() -> bool:
	if character.get_action_pressed("move_up"):
		if not character.get_action_pressed("move_left") and not character.get_action_pressed("move_right"):
			return true
	return false

func change_animation_if_falling(_s) -> void :
	EndAbility()
	if not go_upwards:
		character.start_dashfall()

func on_dash() -> void :
	if pressed_inverse_direction():
		pass

func pressed_inverse_direction() -> bool:
	if timer > 0.1:
		if get_pressed_direction() != 0 and initial_direction != get_pressed_direction():
			return true
	else:
		initial_direction = get_pressed_direction()
	return false

func check_for_let_go_of_input() -> void :
	if input == 0 or pressed_inverse_direction():
		has_let_go_of_input = true

func emit_particles(_particles, _value: = false) -> void :
	pass

func _ResetCondition() -> bool:
	if has_let_go_of_input and Input.is_action_just_pressed(actions[0]):
		if character.get_vertical_speed() > 0:
			if hover.active and hover.current_air_jumps > 0 and airdash_count > 0:
				hover.reduce_air_jumps()
				return true
			elif infinite_airdashes and airdash_count > 0:
				return true
	return false

func _StartCondition() -> bool:
	if hover.current_air_jumps <= 0:
		if not upgraded:
			return false
	if should_dash() and not execute_dash_up() or upgraded and execute_dash_up() and should_dash_up():
		if is_executing_WallJump():
			return false
		elif airdash_count > 0:
			return true
	return false

func reduce_air_jumps() -> void :
	if should_reduce_airjumps:
		hover.reduce_air_jumps()
		should_reduce_airjumps = false

func is_executing_DashAirJump() -> bool:
	return hover.executing and abs(hover.horizontal_velocity) > 90

func is_executing_WallJump() -> bool:
	if dash_wall_jump.executing and dash_wall_jump.timer < 0.2:
		return true
	elif wall_jump.executing and wall_jump.timer < 0.2:
		return true
	return false

func is_executing_DashJump() -> bool:
	return character.dashjumps_since_jump > 0

func is_able_to_airjump() -> bool:
	return hover.active and hover.current_air_jumps > 0

func _Interrupt() -> void :
	last_time_pressed = 0.0
	initial_sound = true
	dash_duration = initial_duration
	dash_particle.rotation_degrees = 0
	dash_particle.position = Vector2( - 16, 4)
	animatedSprite.rotation_degrees = 0
	animatedSprite.position.x = 0
	if not changed_animation:
		character.call_deferred("increase_hitbox")
	emit_particles(particles, false)
	invulnerable(false)
	character.set_horizontal_speed(0)
	if not go_upwards:
		character.set_vertical_speed(0)
	zero_bonus_horizontal_speed()
	

func play_sound_on_initialize() -> void :
	if initial_sound:
		.play_sound_on_initialize()

func _EndCondition() -> bool:
	if pressing_towards_wall() or character.is_on_floor():
		return true
	return false
