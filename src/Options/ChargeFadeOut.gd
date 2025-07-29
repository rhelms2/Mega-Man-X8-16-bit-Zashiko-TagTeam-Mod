extends X8OptionButton

func setup() -> void :
	set_charge_fadeout(get_charge_fadeout())

func increase_value() -> void :
	set_charge_fadeout( not get_charge_fadeout())

func decrease_value() -> void :
	set_charge_fadeout( not get_charge_fadeout())

func set_charge_fadeout(value: bool) -> void :
	
	Configurations.set("ChargeFadeOut", value)
	display_charge()

func get_charge_fadeout():
	if Configurations.exists("ChargeFadeOut"):
		return Configurations.get("ChargeFadeOut")
	return true

func display():
	pass

func display_charge():
	if Configurations.get("ChargeFadeOut"):
		display_value("ON_VALUE")
	else:
		display_value("OFF_VALUE")
