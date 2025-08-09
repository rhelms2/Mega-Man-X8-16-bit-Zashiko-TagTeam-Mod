extends Attack
class_name Turn

export var new_direction := 1

func start_by_signal():
	if should_start():
		if character.get_facing_direction() != new_direction:
			ExecuteOnce()
		
func _Setup():
	character.set_direction(new_direction)
	play_sound(sound)
	._Setup()
