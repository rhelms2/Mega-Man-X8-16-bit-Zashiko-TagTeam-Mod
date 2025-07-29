extends X8OptionButton

export  var key: = "Music"
var step: = 1.0
	
func setup() -> void :
	set_volume(get_volume())

func increase_value() -> void :
	set_volume(get_volume() + step)

func decrease_value() -> void :
	set_volume(get_volume() - step)

func get_volume():
	if Configurations.get(key + "Volume") != null:
		return Configurations.get(key + "Volume")
	return get_actual_volume()

func get_actual_volume():
	return AudioServer.get_bus_volume_db(get_id())

func set_volume(value):
	var v = clamp(value, - 80, 6)
	Configurations.set(key + "Volume", v)
	AudioServer.set_bus_volume_db(get_id(), get_volume())
	display_volume()

func display_volume() -> void :
	display_value(round(100 * inverse_lerp( - 80, 6, get_actual_volume())))

func get_id() -> int:
	return AudioServer.get_bus_index(key)
