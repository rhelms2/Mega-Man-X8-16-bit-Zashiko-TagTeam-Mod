extends WeaponShot

var maximum_velocity := 1.0
var initial_dir := 1
var executing_moves = []

func launch_setup(direction, _launcher_velocity := 0.0):
	initial_dir = direction
	maximum_velocity = horizontal_velocity * 4
	set_horizontal_speed(horizontal_velocity * initial_dir)

func _physics_process(delta: float) -> void:
	if horizontal_velocity < maximum_velocity:
		horizontal_velocity += delta * 500
		set_horizontal_speed(horizontal_velocity * initial_dir)

func _on_visibilityNotifier2D_screen_exited():
	destroy()
