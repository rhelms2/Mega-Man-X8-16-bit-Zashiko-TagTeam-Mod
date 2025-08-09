extends RigidBody2D
onready var parent = get_parent()

func add_conveyor_belt_speed(speed: float) -> void :
	parent.add_conveyor_belt_speed(speed)
func reduce_conveyor_belt_speed(speed: float):
	parent.reduce_conveyor_belt_speed(speed)
