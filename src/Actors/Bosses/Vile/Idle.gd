extends BossIdle


func on_desperation() -> void:
	animation = "flight"

func _Setup() -> void:
	turn_and_face_player()
	play_animation(animation)

func _Update(_delta):
	if animation != "flight":
		process_gravity(_delta)
