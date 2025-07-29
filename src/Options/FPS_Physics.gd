extends X8OptionButton

var fps_options: = [15, 30, 45, 50, 55, 60, 75, 120, 144, 240]

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
	if Configurations.get("FPS_PHYSICS"):
		return Configurations.get("FPS_PHYSICS")
	return 60

func set_fps(value: int) -> void :
	Configurations.set("FPS_PHYSICS", value)
	Engine.set_iterations_per_second(value)
	display_value(value)
