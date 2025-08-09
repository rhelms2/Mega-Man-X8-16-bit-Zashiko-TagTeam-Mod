extends X8OptionButton


func setup() -> void :
	set_skipgateway(get_skipgateway())
	display()

func increase_value() -> void :
	var val = get_skipgateway()
	val = (val + 1) %3
	set_skipgateway(val)
	display()

func decrease_value() -> void :
	var val = get_skipgateway()
	val = (val - 1 + 3) %3
	set_skipgateway(val)
	display()

func set_skipgateway(value: int) -> void :
	Configurations.set("SkipGateway", value)

func get_skipgateway() -> int:
	if Configurations.exists("SkipGateway"):
		return Configurations.get("SkipGateway")
	return 0

func display() -> void :
	match get_skipgateway():
		0:
			display_value("OFF_VALUE")
		1:
			display_value("ON_VALUE")
		2:
			display_value("ON_VALUE_B")
