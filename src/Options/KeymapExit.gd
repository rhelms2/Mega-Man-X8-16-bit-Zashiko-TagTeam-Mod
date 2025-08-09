extends X8TextureButton


func _ready() -> void :
	var _s = get_parent().connect("visibility_changed", self, "_on_visibility_changed")

func on_press() -> void :
	modulate = Color(3, 3, 3, 1)
	reset_tween()
	tween.tween_property(self, "modulate", Color.white, 0.35)
	menu.end()

func _on_visibility_changed() -> void :
	if get_parent().visible:
		call_deferred("grab_focus")
