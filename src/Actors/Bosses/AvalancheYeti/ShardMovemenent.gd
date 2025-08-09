extends AttackAbility


func _ready() -> void:
	pass

func _Update(delta: float) -> void:
	var rotate_speed := (delta * 8)
	animatedSprite.rotate(rotate_speed)
	set_horizontal_speed(horizontal_velocity * cos(timer * 3))
	if timer > 20:
		character.queue_free()
