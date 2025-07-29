extends X8OptionButton


func setup() -> void :
	set_showdebug(get_showdebug())
	display()

func increase_value() -> void :
	set_showdebug( not get_showdebug())
	display()

func decrease_value() -> void :
	set_showdebug( not get_showdebug())
	display()

func set_showdebug(value: bool) -> void :
	Configurations.set("ShowDebug", value)

func get_showdebug():
	if Configurations.get("ShowDebug"):
		return true
	return false

func display():
	if Configurations.get("ShowDebug"):
		display_value("ON_VALUE")
	else:
		display_value("OFF_VALUE")
