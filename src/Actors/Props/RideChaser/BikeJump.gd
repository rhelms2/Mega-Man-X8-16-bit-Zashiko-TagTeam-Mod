extends BikeMovement
class_name BikeJump

export var max_jump_time := 0.65
export var acceleration := 250.0
export var deacceleration := 50.0
export var brake_speed = 180.0
var minimum_speed = 0.0
export var leeway_time := 0.1
export var fullspeed_proportion := 0.18
export var minimum_upwards_time := 0.0
var fullspeed_time := 0.0
var slowdown_time := 0.0
var stopped_input := false
var speed_at_jump_start:= 0.0
var extra_vertical_speed := 0.0
func get_shot_adust_position() -> Vector2:
	return Vector2(-5, -20)

func _ready() -> void:
	if active:
# warning-ignore:return_value_discarded
		character.listen("headbump", self, "on_headbump")

func _Setup() -> void:
	Event.emit_signal("jump")
	extra_vertical_speed = 0
	if get_vertical_speed() < 0:
		extra_vertical_speed = get_vertical_speed()
	fullspeed_time = 0
	slowdown_time = 0
	stopped_input = false
	speed_at_jump_start = abs(get_actual_speed())
	update_bonus_horizontal_speed()
	character.set_vertical_speed(extra_vertical_speed/ 1.8 -jump_plus_ground_velocity - speed_at_jump_start/9) 
	

func _Update(_delta: float) -> void:
	delta = _delta
	if_no_input_zero_vertical_speed()
	#ascent_with_slowdown_after_delay(_delta)
	process_gravity(_delta, 700)
	process_speed()
	force_movement_regardless_of_direction(get_actual_speed())

func process_speed():
	if is_accelerating():
		accelerate(acceleration)
	elif is_deaccelerating(minimum_speed):
		deaccelerate(deacceleration, minimum_speed)
	elif is_braking():
		brake(brake_speed)
	elif should_stop():
		stop()

func is_deaccelerating(_minimum_speed) -> bool:
	return is_deaccelerating_right(_minimum_speed) or is_deaccelerating_left(_minimum_speed)

func if_no_input_zero_vertical_speed() -> void:
	if character.get_vertical_speed() < 0:
		if no_input_after_minimum_time():
			character.set_vertical_speed(0)
			stopped_input = true

func no_input_after_minimum_time() -> bool:
	return timer > minimum_upwards_time and input == 0

func ascent_with_slowdown_after_delay(_delta :float) -> void:
	if not stopped_input and calculate_slowdown_value() != 0:
		if can_go_up_at_full_velocity():
			character.set_vertical_speed(extra_vertical_speed -jump_plus_ground_velocity - speed_at_jump_start) 
			fullspeed_time = fullspeed_time + _delta
		else:
			character.set_vertical_speed((extra_vertical_speed - jump_plus_ground_velocity - speed_at_jump_start/1.5) * calculate_slowdown_value()) 
			slowdown_time = slowdown_time + _delta

func can_go_up_at_full_velocity() -> bool:
	return fullspeed_time / max_jump_time  < fullspeed_proportion  # fullspeed_prop

func extra_duration() -> float:
	return (extra_vertical_speed - speed_at_jump_start)/horizontal_velocity/6

func calculate_slowdown_value() -> float:
	var sv = (max_jump_time - fullspeed_time) - slowdown_time / (max_jump_time - fullspeed_time)
	if sv < 0:
		return 0.0
	return sv

func _StartCondition() -> bool:
	#if prevent_jump_from_clamping_slope_jump_speed():
	#	return false
	
	if character.is_on_floor():
		return true
	else:
		if character.time_since_on_floor < leeway_time:
			return true
	return false

func prevent_jump_from_clamping_slope_jump_speed() -> bool:
	if character.get_vertical_speed() < -jump_velocity/1.3:
		return true
	return false

func _EndCondition() -> bool:
	if timer > 0.25:
		if character.is_on_floor():
			return true
	return false

func play_animation_on_initialize():
	if animation:
		character.play_animation_once(animation)
		character.animatedSprite.set_frame(0)

func on_headbump() -> void:
	if executing:
		character.set_vertical_speed(0)
		stopped_input = true
		
