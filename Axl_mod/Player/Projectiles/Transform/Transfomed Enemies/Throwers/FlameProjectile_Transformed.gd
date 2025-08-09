extends GenericProjectile
onready var animated_sprite: AnimatedSprite = $animatedSprite

func flip() -> void :
	animated_sprite.rotation_degrees = - 90

func _Setup() -> void :
	animated_sprite.playing = true
	if rand_range(0.0, 1.0) > 0.5:
		animatedSprite.flip_h = true
func _OnHit(_target_remaining_HP) -> void :
	pass
func _Update(_d) -> void :
	if timer > 0.75:
		disable_damage()
		animated_sprite.modulate = Color(1, 1, 1, 1 - timer)
	set_horizontal_speed(get_horizontal_speed() * (1 - timer / 30))
	if timer > 1:
		destroy()
