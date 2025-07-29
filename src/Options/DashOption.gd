extends X8OptionButton

func setup() -> void :
	set_dash(get_dash())

func increase_value() -> void :
	set_dash( not get_dash())

func decrease_value() -> void :
	set_dash( not get_dash())

func set_dash(value: bool) -> void :
	Configurations.set("DashCommand", value)
	display_dash()

func get_dash():
	if Configurations.exists("DashCommand"):
		return Configurations.get("DashCommand")
	return false

func display_dash():
	if Configurations.get("DashCommand"):
		display_value("ON_VALUE")
	else:
		display_value("OFF_VALUE")
