extends FireDash
onready var wall_check_right: RayCast2D = $wallCheck_right
onready var wall_check_left: RayCast2D = $wallCheck_left
onready var wall_check_down: RayCast2D = $wallCheck_down
onready var wall_check_up: RayCast2D = $wallCheck_up
onready var wallchecks = [wall_check_right, wall_check_left, wall_check_down, wall_check_up]
onready var fire: Particles2D = $Fire
onready var explosion: Particles2D = $Explosion
onready var wallhit: AudioStreamPlayer2D = $wallhit

signal wallhit(side)

func _Update(_delta: float) -> void :
	set_visual_direction()
	if ending and timer > 1:
		finish()
	else:
		signal_collisions()
	
func signal_collisions() -> void :
	for check in wallchecks:
		if check.is_colliding():
			emit_signal("wallhit", check.name.trim_prefix("wallCheck_"))
			return

func explode() -> void :
	fire.restart()
	fire.emitting = true
	explosion.restart()
	explosion.emitting = true
	wallhit.play()
	wallhit.pitch_scale += 0.12
	Event.emit_signal("screenshake", 0.7)
