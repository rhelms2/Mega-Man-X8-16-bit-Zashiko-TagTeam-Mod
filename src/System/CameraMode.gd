extends Node
class_name CameraMode

export  var x_axis: = true
onready var camera: Camera2D = $".."

func _ready() -> void :
	camera.include_mode(self)

func get_target() -> Vector2:
	return camera.player_pos()

func activate(_target) -> void :
	
	if x_axis:
		camera.current_mode_x = self
	else:
		camera.current_mode_y = self
	setup()

func setup() -> void :
	pass

func deactivate() -> void :
	if x_axis:
		camera.current_mode_x = null
	else:
		camera.current_mode_y = null

func update(_delta) -> Vector2:
	return Vector2.ZERO

func is_executing() -> bool:
	if x_axis:
		return camera.current_mode_x == self
	return camera.current_mode_y == self
