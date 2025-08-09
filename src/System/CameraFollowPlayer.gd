extends CameraMode
	
func update(_delta) -> Vector2:
	var new_position: = camera.global_position
	if x_axis:
		if camera.is_constrained_horizontally():
			new_position.x = camera.get_boundary_position_right()
			return new_position
			
		new_position.x = get_target().x
		if camera.is_over_right_limit():
			new_position.x = camera.get_boundary_position_right()
		elif camera.is_over_left_limit():
			new_position.x = camera.get_boundary_position_left()
	else:
		if camera.is_constrained_vertically():
			new_position.y = camera.get_boundary_position_bot()
			return new_position

		new_position.y = get_target().y
		if camera.is_over_top_limit():
			new_position.y = camera.get_boundary_position_top()
		elif camera.is_over_bottom_limit():
			new_position.y = camera.get_boundary_position_bot()
	return new_position

func is_valid_position() -> bool:
	
	return false

func is_limited_horizontally() -> bool:
	if camera.is_over_right_limit():
		return true
	elif camera.is_over_left_limit():
		return true
	return false

func is_limited_vertically() -> bool:
	if camera.is_over_bottom_limit():
		return true
	elif camera.is_over_top_limit():
		return true
	return false

