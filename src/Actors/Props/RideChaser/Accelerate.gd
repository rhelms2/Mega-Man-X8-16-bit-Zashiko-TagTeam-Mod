extends BikeMovement
class_name Accelerate

export var acceleration := 400.0
#var camera_offset_set := false

func _Setup() -> void:
	set_camera_offset(64,1.5)

func play_animation_on_initialize() -> void:
	if character.get_animation() == "break" or character.get_animation() == "break_end":
		play_animation("break_end")
	elif character.get_animation() == "wheelie" or character.get_animation() == "wheelie_end":
		play_animation("wheelie_end")
	elif character.get_animation() == "stop" or character.get_animation() == "stop_end":
		play_animation("stop_end")
	elif character.get_animation() == "turn":
		play_animation("turn")

func _StartCondition() -> bool:
	if character.is_on_floor():
		if character.is_colliding_with_wall() != 0:
			if character.is_colliding_with_wall() == get_pressed_direction():
				return false
		if character.get_facing_direction() == get_pressed_direction():
			return true
	return false

func _EndCondition() -> bool:
	if not character.is_on_floor():
		return true
	if get_pressed_direction() == 0:
		return true
	if character.get_facing_direction() != get_pressed_direction():
		return true
	if character.is_colliding_with_wall() != 0:
		if character.is_colliding_with_wall() == get_pressed_direction():
			return true
	return false

func process_speed():
	accelerate(acceleration)
	deaccelerate(acceleration/2, horizontal_velocity)

func should_execute_on_hold() -> bool:
	return true
