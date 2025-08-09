extends RigidBody2D
onready var conveyor_box: StaticBody2D = $".."


func void_touch() -> void :
	conveyor_box.void_touch()
