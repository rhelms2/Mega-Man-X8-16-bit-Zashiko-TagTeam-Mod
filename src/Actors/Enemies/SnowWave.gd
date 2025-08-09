extends WeaponShot

func _ready() -> void:
	call_deferred("setup_particles")

func setup_particles():
	$particles2D.position.x = $particles2D.position.x * get_facing_direction()
	

func hit(_body) -> void:
	if hit_sound:
		$audioStreamPlayer2D.stream = hit_sound
		$audioStreamPlayer2D.play()
	_body.damage(damage, self)
	emit_signal("hit")

func _on_visibilityNotifier2D_screen_exited() -> void:
	countdown_to_destruction = 0.01
	disable_damage()
