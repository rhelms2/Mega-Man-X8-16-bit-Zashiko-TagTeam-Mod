extends Idle

func _on_animatedSprite_animation_finished() -> void:
	if executing: 
		if not is_shooting() and is_playing_recover():
			if character.is_low_health():
				character.play_animation("weak")
			else:
				character.play_animation("idle")

func is_playing_recover() -> bool:
	return character.get_animation() == "recover"

func is_shooting() -> bool:
	return character.get_animation_layer().resource_name == "pointing_cannon"
