extends AttackAbility
onready var land: AudioStreamPlayer2D = $land


	
func _Setup() -> void:
	turn_and_face_player()
	play_animation("Jump")
	set_vertical_speed(-400)
	land.play()

func _Update(delta) -> void:
	process_gravity(delta)
	force_movement(180)
	
	if timer > 0.1 and character.is_on_floor():
		land.play()
		EndAbility()
