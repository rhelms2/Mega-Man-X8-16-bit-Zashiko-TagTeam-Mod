extends X8OptionButton

var fps_options: = [15, 30, 45, 50, 55, 60, 75, 120, 144, 240, 0]

func setup() -> void :
	set_fps(get_fps())

func increase_value() -> void :
	var index: = fps_options.find(get_fps())
	index = (index + 1) %fps_options.size()
	set_fps(fps_options[index])

func decrease_value() -> void :
	var index: = fps_options.find(get_fps())
	index = (index - 1 + fps_options.size()) %fps_options.size()
	set_fps(fps_options[index])

func get_fps() -> int:
	if Configurations.get("FPS"):
		return Configurations.get("FPS")
	return 0

func set_fps(value: int) -> void :
	Configurations.set("FPS", value)
	Engine.target_fps = value
	if value == 0:
		display_value(tr("FPS_UNCAPPED"))
	else:
		display_value(value)
