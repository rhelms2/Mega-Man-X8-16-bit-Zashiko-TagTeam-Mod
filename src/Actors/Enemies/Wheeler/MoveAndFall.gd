extends AttackAbility
class_name WheelerHorizontalMovement

func _Setup():
	pass

func _Update(delta):
	force_movement(get_horizontal_velocity())
	process_gravity(delta)
