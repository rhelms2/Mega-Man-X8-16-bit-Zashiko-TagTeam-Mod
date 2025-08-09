extends Light2D
var light_tween: SceneTreeTween

func light(new_energy, new_scale, new_color) -> void :
	if light_tween:
		light_tween.kill()
	energy = new_energy
	scale = new_scale
	color = new_color

func dim(duration: float, final_energy: = 0.35) -> void :
	if light_tween:
		light_tween.kill()
	light_tween = create_tween()
	light_tween.set_parallel()
	light_tween.tween_property(self, "energy", final_energy, duration)
	light_tween.tween_property(self, "scale", Vector2(1, 1), duration)
	light_tween.tween_property(self, "color", Color.white, duration)
