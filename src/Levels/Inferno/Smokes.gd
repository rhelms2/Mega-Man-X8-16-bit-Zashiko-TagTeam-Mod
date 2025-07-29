extends Particles2D


func _physics_process(delta: float) -> void :
	
	
	
	global_position.y = GameManager.camera.get_camera_screen_center().y

func get_x_relative_to_camera_center() -> float:
	return GameManager.camera.get_camera_screen_center().x - global_position.x

func get_y_relative_to_camera_center() -> float:
	return GameManager.camera.get_camera_screen_center().y - global_position.y
