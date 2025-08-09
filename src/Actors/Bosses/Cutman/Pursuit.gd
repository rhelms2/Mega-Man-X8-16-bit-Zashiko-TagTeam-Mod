extends AttackAbility


func _ready() -> void:
	pass

func _Setup() -> void:
	turn_and_face_player()
	play_animation("Walk")

func _Update(delta) -> void:
	process_gravity(delta)
	force_movement(140)
	
	if timer > 1:
		EndAbility()
	elif timer > .1 and is_colliding_with_wall():
		EndAbility()
