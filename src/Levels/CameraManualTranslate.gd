extends CameraMode
class_name TranslateCameraMode2

const translate_time := 2
var initial_camera_position : Vector2
var timer := 0.0

func activate(_target) -> void:
	.activate(_target)
	start_translate()

func start_translate() -> void:
	#initial_camera_position = camera.global_position
	timer = 0.01

func update(delta: float) -> Vector2:
	var new_position : Vector2
	if is_translating():
		new_position = translate()
		timer += delta
		
		if has_reached_player():
			deactivate()
	return new_position

func translate() -> Vector2:
	var weight = inverse_lerp(0, translate_time, timer)
	var pos : Vector2
	pos.x = (lerp(camera.global_position.x, get_correct_position().x, weight))
	pos.y = (lerp(camera.global_position.y, get_correct_position().y, weight))
	
	return pos

func get_correct_position () -> Vector2:
	return camera.get_nearest_position()

func deactivate() -> void:
	if x_axis:
		camera.current_mode_x = null
	else:
		camera.current_mode_y = null

func is_translating() -> bool:
	return timer > 0

func has_reached_player() -> bool:
	if x_axis:
		if not camera.is_too_far_x():
			return true
	else:
		if not camera.is_too_far_y():
			return true
		
	return timer >= translate_time
