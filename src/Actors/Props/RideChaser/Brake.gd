extends BikeMovement
class_name Break

export var brake_speed = 640.0

func _StartCondition() -> bool:
	if character.is_on_floor():
		if get_actual_speed() < 0 and character.get_facing_direction() > 0:
			return false
		if get_actual_speed() > 0 and character.get_facing_direction() < 0:
			return false
		if get_actual_speed() != 0 and get_pressed_direction() != 0:
			if character.get_facing_direction() != get_pressed_direction():
				return true
	return false

func _EndCondition() -> bool:
	if not character.is_on_floor():
		return true
	if get_pressed_direction() == 0:
		return true
	if get_actual_speed() == 0:
		return true
	if get_actual_speed() < 0 and get_pressed_direction() < 0:
		return true
	if get_actual_speed() > 0 and get_pressed_direction() > 0:
		return true
	if character.get_facing_direction() == get_pressed_direction():
		return true
	return false

func process_speed():
	brake(brake_speed)

func _Setup():
	#if abs(get_actual_speed()) > 200:
	character.emit_land_particles(abs(get_actual_speed())/1000)

func _Interrupt():
	character.stop_land_particles()
	
func play_sound_on_initialize():
	if sound:
		play_sound(sound, false)
func should_execute_on_hold() -> bool:
	return true
