extends ChargedBuster

export var vertical_velocity := 320.0

func launch_setup(direction, _launcher_velocity := 0.0):
	set_vertical_speed(vertical_velocity)
	set_horizontal_speed(horizontal_velocity * direction)
