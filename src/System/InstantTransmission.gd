extends CameraMode

var reached_destination: bool = false


func setup() -> void :
	reached_destination = false

func update(_delta: float) -> Vector2:
	if reached_destination:
		deactivate()
	call_deferred("wait_a_frame")
	return transmission()

func wait_a_frame() -> void :
	reached_destination = true

func transmission() -> Vector2:
	var new_position: = camera.global_position
	if camera.is_over_right_limit():
		new_position.x = camera.get_boundary_position_right()
	elif camera.is_over_left_limit():
		new_position.x = camera.get_boundary_position_left()
	if camera.is_over_top_limit():
		new_position.y = camera.get_boundary_position_top()
	elif camera.is_over_bottom_limit():
		new_position.y = camera.get_boundary_position_bot()
	return new_position
