extends WheelerHorizontalMovement

func _Update(delta):
	if character.is_on_floor() and character.get_vertical_speed() >= 0:
		set_vertical_speed( - jump_velocity)
	else:
		._Update(delta)

func _EndCondition() -> bool:
	return timer > 0.2 and character.is_on_floor()
