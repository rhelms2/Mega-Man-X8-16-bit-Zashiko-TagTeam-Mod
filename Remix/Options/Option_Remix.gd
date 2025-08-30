extends X8OptionButton

func setup() -> void :
	set_songremix(get_songremix())
	display()

func increase_value() -> void :
	set_songremix( not get_songremix())
	display()

func decrease_value() -> void :
	set_songremix( not get_songremix())
	display()

func set_songremix(value: bool) -> void :
	Configurations.set("SongRemix", value)
	

func get_songremix():
	Configurations.set("SongRemix", false)
	if Configurations.exists("SongRemix"):
		return Configurations.get("SongRemix")
	return false

func display():
	if get_songremix():
		display_value("ON_VALUE")
	else:
		display_value("OFF_VALUE")
