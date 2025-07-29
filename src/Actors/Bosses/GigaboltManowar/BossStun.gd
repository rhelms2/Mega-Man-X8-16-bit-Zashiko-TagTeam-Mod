extends BossStun

export var after_animation := "idle"

func _EndCondition() -> bool:
	return timer > 0.45

func _Interrupt() -> void:
	play_animation(after_animation)
	force_movement(0)
	set_vertical_speed(0)
