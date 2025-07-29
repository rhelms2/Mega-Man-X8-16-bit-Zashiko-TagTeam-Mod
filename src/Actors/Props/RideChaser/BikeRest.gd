extends BikeMovement
class_name BikeRest

func _StartCondition() -> bool:
	if character.is_on_floor():
		return true
	return false

func _EndCondition() -> bool:
	if not character.is_on_floor():
		return true
	return false
	

func _Update(_delta) -> void:
	if should_change_direction():
		change_direction()

func _Setup():
	update_bonus_horizontal_only_conveyor()
	character.set_horizontal_speed(0)

func should_change_direction() -> bool:
	return get_pressed_direction() != 0 and get_pressed_direction() != character.get_facing_direction()

func change_direction() -> void:
	set_direction_as_pressed_direction()
	play_animation("turn")
