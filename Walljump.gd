extends Jump
class_name WallJump

export var start_delay := 0.128
export var move_away_duration := 0.08
export var dash_action := "dash"
var maximum_moveaway := 0.0
var move_away_speed := 75
var moveaway := 0.0
var walljump_direction := 0
var headbumped := false
var emitted_jump_signal := false
onready var dash_wall_jump: Node2D = $"../DashWallJump"

onready var particles = character.get_node("animatedSprite").get_node("WallJump Particle")

func emit_jump_signal():
	pass
	
func _Setup() -> void:
	._Setup()
	emitted_jump_signal = false
	character.emit_signal("walljump")
	walljump_direction = - character.is_in_reach_for_walljump()
	character.set_direction(- walljump_direction)
	maximum_moveaway = horizontal_velocity 
	moveaway = horizontal_velocity * walljump_direction
	headbumped = false
	particles.emitting = true
	character.set_horizontal_speed(0)
	character.set_vertical_speed(0)
	
	character.position.x = character.position.x + 2 * walljump_direction
	character.position.y = character.position.y - 2

func _Update(delta:float) -> void:
	if not execute_dashwalljump_on_input():
		._Update(delta)

func execute_dashwalljump_on_input() -> bool:
	if timer < 0.25 and Input.is_action_just_pressed(dash_action):
		dash_wall_jump.override_timer = timer
		dash_wall_jump.start_right_away()
		return true
	return false
	

func _StartCondition() -> bool:
	if character.is_on_floor():
		return false
	else:
		if character.is_in_reach_for_walljump() != 0:
			if not character.get_action_pressed(dash_action):
				return true
	return false

func _ResetCondition() -> bool:
	if character.is_in_reach_for_walljump():
		if has_released_input_and_is_pressing_again():
			return true
			
	return false

func has_released_input_and_is_pressing_again() -> bool:
	return has_let_go_of_input and input > 0

func _EndCondition() -> bool:
	if timer > 0.05 + start_delay:
		if facing_a_wall() and character.get_vertical_speed() > 0:
			return true 
	
	return ._EndCondition()

func if_no_input_zero_vertical_speed() -> void:
	if timer > move_away_duration:
		.if_no_input_zero_vertical_speed()

func set_movement_and_direction(horizontal_speed:float, _delta:= 0.016) -> void:
	if delay_has_expired():
		if delay_and_move_away_duration_have_expired():
			.set_movement_and_direction(horizontal_speed)
		else:
			move_away_from_wall(_delta)

func ascent_with_slowdown_after_delay(_delta :float) -> void:
	if delay_has_expired():
		if not emitted_jump_signal:
			character.emit_signal("jump")
			emitted_jump_signal = true
		.ascent_with_slowdown_after_delay(_delta)

func process_gravity(_delta:float, gravity := default_gravity, _s = "null") -> void:
	if delay_has_expired():
		.process_gravity(_delta, gravity)

func move_away_from_wall(_delta: float):
	character.set_horizontal_speed(move_away_speed * -character.get_facing_direction())

func pressing_towards_wall() -> bool:
	return get_pressed_direction() != 0 and get_pressed_direction() != walljump_direction

func calculate_reducing_move_away_speed(_delta : float) -> float:
	return moveaway - (horizontal_velocity)  * _delta * walljump_direction

func move_away_speed_down_to_zero():
	return walljump_direction == 1 and moveaway < 0 or \
			walljump_direction == -1 and moveaway > 0

func delay_and_move_away_duration_have_expired() -> bool:
	return timer > start_delay + move_away_duration or headbumped

func delay_has_expired() -> bool:
	return timer > start_delay
	
func on_headbump() -> void:
	if executing:
		character.set_vertical_speed(0)
		stopped_input = true
		headbumped = true
