extends X8OptionButton


func _ready() -> void :
	Event.connect("translation_updated", self, "display_skip_dialog")
	
func setup() -> void :
	set_skip_dialog(get_skip_dialog())

func increase_value() -> void :
	set_skip_dialog( not get_skip_dialog())

func decrease_value() -> void :
	set_skip_dialog( not get_skip_dialog())

func set_skip_dialog(value: bool) -> void :
	Configurations.set("SkipDialog", value)
	
	display_skip_dialog()

func get_skip_dialog():
	if Configurations.exists("SkipDialog"):
		return Configurations.get("SkipDialog")
	return false

func display_skip_dialog():
	if Configurations.get("SkipDialog"):
		display_value("ON_VALUE")
	else:
		display_value("OFF_VALUE")
