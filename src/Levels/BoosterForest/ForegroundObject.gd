extends Node2D

export var direction := -1
export var factor := 7.0
onready var parallax_object = $sprite

func _physics_process(_delta: float) -> void:
	var new_x = get_x_relative_to_camera_center()
	var new_y = get_y_relative_to_camera_center()
	var new_pos = Vector2 (new_x,new_y)
	parallax_object.position = new_pos * direction/factor

func get_x_relative_to_camera_center() -> float:
	return GameManager.camera.get_camera_screen_center().x - global_position.x 

func get_y_relative_to_camera_center() -> float:
	return GameManager.camera.get_camera_screen_center().y - global_position.y
