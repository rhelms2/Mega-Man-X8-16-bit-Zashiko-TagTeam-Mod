extends X8OptionButton


func setup() -> void :
	set_showigt(get_showigt())
	display_igt()

func increase_value() -> void :
	set_showigt( not get_showigt())
	display_igt()

func decrease_value() -> void :
	set_showigt( not get_showigt())
	display_igt()

func set_showigt(value: bool) -> void :
	Configurations.set("ShowIGT", value)

func get_showigt():
	if Configurations.exists("ShowIGT"):
		return Configurations.get("ShowIGT")
	return false

func display_igt():
	if Configurations.get("ShowIGT"):
		display_value("ON_VALUE")
	else:
		display_value("OFF_VALUE")
