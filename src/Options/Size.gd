extends X8OptionButton

const native = Vector2(398, 224)
const w_size: = "WindowSize"
var current_multiplier = 1


func setup() -> void :
	current_multiplier = get_windowsize()
	display_value(current_multiplier)
	set_windowsize(current_multiplier)

func increase_value() -> void :
	increase_multiplier(1)
	set_windowsize(current_multiplier)
	
func decrease_value() -> void :
	increase_multiplier( - 1)
	set_windowsize(current_multiplier)

func set_windowsize(multiplier):
	current_multiplier = multiplier
	Configurations.set(w_size, current_multiplier)
	display_value(current_multiplier)
	if not Configurations.get("Fullscreen"):
		OS.set_window_size(native * current_multiplier)
	pass

func get_windowsize():
	var ws = Configurations.get(w_size)
	if ws:
		return ws
	else:
		return 3

func increase_multiplier(value) -> void :
	current_multiplier = clamp(current_multiplier + value, 1, 10)
