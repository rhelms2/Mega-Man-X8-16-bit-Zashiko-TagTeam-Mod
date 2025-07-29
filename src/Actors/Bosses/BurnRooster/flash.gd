extends SigmaFlash


func start() -> void :
	tween_brightness.reset()
	scale.y = initial_scale
	modulate = Color(initial_color.r, initial_color.g, initial_color.b, initial_alpha)
	tween_brightness.create()
	tween_brightness.set_parallel()
	tween_brightness.set_ignore_pause_mode()
	tween_brightness.add_attribute("modulate", Color(final_color.r, final_color.g, final_color.b, 0.0), duration)
	if tween_scale_y:
		tween_brightness.add_attribute("scale:y", 0.5, duration)

func _on_Intro_prepared() -> void :
	visible = true
