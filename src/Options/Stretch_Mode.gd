extends X8OptionButton


func setup() -> void :
	_set_stretch_mode(_get_stretch_mode())
	display_stretch_mode()

func increase_value() -> void :
	_set_stretch_mode( not _get_stretch_mode())
	display_stretch_mode()

func decrease_value() -> void :
	_set_stretch_mode( not _get_stretch_mode())
	display_stretch_mode()

func _set_stretch_mode(value: bool) -> void :
	Configurations.set("StretchMode", value)

func _get_stretch_mode() -> bool:
	if Configurations.exists("StretchMode"):
		return Configurations.get("StretchMode")
	return false

func display_stretch_mode() -> void :
	if Configurations.get("StretchMode"):
		display_value("STRETCH_OPTION_VIEWPORT")
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT, SceneTree.STRETCH_ASPECT_KEEP, GameManager.Resolution)
	else:
		display_value("STRETCH_OPTION_2D")
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_KEEP, GameManager.Resolution)
