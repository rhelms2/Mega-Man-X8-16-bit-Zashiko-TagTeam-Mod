extends X8OptionButton

func _ready() -> void :
	Event.connect("translation_updated", self, "display")

func setup() -> void :
	if not Configurations.exists("CRT"):
		set_crt(0)
	else:
		set_crt(get_crt())

func increase_value() -> void :
	if Configurations.exists("CRT"):
		match Configurations.get("CRT"):
			0:
				set_crt(1)
			1:
				set_crt(2)
			2:
				set_crt(0)
			null:
				set_crt(1)
	else:
		set_crt(1)

func decrease_value() -> void :
	if Configurations.exists("CRT"):
		match Configurations.get("CRT"):
			0:
				set_crt(2)
			1:
				set_crt(0)
			2:
				set_crt(1)
			null:
				set_crt(2)
	else:
		set_crt(2)


func set_crt(value: int) -> void :
	Configurations.set("CRT", value)
	display()

func get_crt() -> int:
	if Configurations.exists("CRT"):
		return Configurations.get("CRT")
	else:
		return 0

func display():
	if Configurations.exists("CRT"):
		if Configurations.get("CRT") == 0:
			display_value("OFF_VALUE")
		elif Configurations.get("CRT") == 1:
			display_value("LIGHT_VALUE")
		elif Configurations.get("CRT") == 2:
			display_value("STRONG_VALUE")
	else:
		display_value("OFF_VALUE")
