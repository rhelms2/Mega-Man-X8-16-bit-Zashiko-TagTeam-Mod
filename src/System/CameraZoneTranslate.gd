extends CameraMode
class_name ZoneTranslateCameraMode

export  var translate_time: float = 0.85

var initial_camera_position: Vector2
var timer: float = 0.0


func activate(_target) -> void :
	.activate(_target)
	timer = 0.01
	initial_camera_position = camera.global_position

func update(delta: float) -> Vector2:
	var new_position: Vector2
	if is_translating():
		new_position = translate()
		timer += delta
		
		if has_reached_player():
			deactivate()
	return new_position

func translate() -> Vector2:
	var weight = inverse_lerp(0, translate_time, timer)
	var pos: Vector2 = Vector2.ZERO
	pos.x = lerp(initial_camera_position.x, camera.get_nearest_position().x, weight)
	pos.y = lerp(initial_camera_position.y, camera.get_nearest_position().y, weight)
	return pos

func is_translating() -> bool:
	return timer > 0

func has_reached_player() -> bool:
	return timer >= translate_time
