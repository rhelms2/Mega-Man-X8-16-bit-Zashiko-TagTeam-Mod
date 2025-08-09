extends BikeMovement
class_name Deaccelerate

export var deacceleration := 200.0
export var minimum_speed = 100.0


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
	if character.is_on_floor() and get_actual_speed() != 0:
		return true
	return false

func _EndCondition() -> bool:
	if not character.is_on_floor():
		return true
	if round(get_actual_speed()) == 0:
		set_actual_speed(0)
		character.set_horizontal_speed(0)
		return true
	return false

func process_speed():
	if should_stop():
		stop()
	if not character.listening_to_inputs:
		if is_deaccelerating(minimum_speed/2):
			deaccelerate(deacceleration, minimum_speed/2)
	elif is_deaccelerating(minimum_speed):
		deaccelerate(deacceleration, minimum_speed)

