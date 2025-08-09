extends X8OptionButton

onready var option_name = get_parent().get_node("OptionName")
var aspect_options = [0, 1]
var current_aspect_index = 0


func replace_option_android():
	if option_name:
		option_name.text = tr("ASPECT_OPTION")

func set_aspect_ratio(value) -> void :
	
	Configurations.set("Aspect", value)
	var aspect_value = get_aspect_ratio()
	if aspect_value == 0:
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_IGNORE, GameManager.Resolution)
	elif aspect_value == 1:
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_KEEP, GameManager.Resolution)
	display()
	
func get_aspect_ratio():
	return Configurations.get("Aspect")

func _ready() -> void :
	if CharacterManager.is_Android():
		replace_option_android()
	else:
		Configurations.listen("value_changed", self, "fullscreen_changed")
	
func fullscreen_changed(key) -> void :
	if key == "Fullscreen":
		display()

func setup() -> void :
	if CharacterManager.is_Android():
		set_aspect_ratio(get_aspect_ratio())
	else:
		set_fullscreen(get_fullscreen())
	display()

func increase_value() -> void :
	if CharacterManager.is_Android():
		current_aspect_index = (current_aspect_index + 1) %aspect_options.size()
		set_aspect_ratio(aspect_options[current_aspect_index])
	else:
		set_fullscreen( not get_fullscreen())
		display()

func decrease_value() -> void :
	if CharacterManager.is_Android():
		current_aspect_index = (current_aspect_index - 1 + aspect_options.size()) %aspect_options.size()
		set_aspect_ratio(aspect_options[current_aspect_index])
	else:
		set_fullscreen( not get_fullscreen())
		display()

func set_fullscreen(value: bool) -> void :
	Configurations.set("Fullscreen", value)
	OS.window_fullscreen = value

func get_fullscreen() -> bool:
	if Configurations.get("Fullscreen"):
		return true
	else:
		return false

func display():
	if CharacterManager.is_Android():
		if get_aspect_ratio() == 0:
			display_value("IGNORE_VALUE")
		elif get_aspect_ratio() == 1:
			display_value("KEEP_VALUE")
	else:
		if Configurations.get("Fullscreen"):
			display_value("ON_VALUE")
		else:
			display_value("OFF_VALUE")
