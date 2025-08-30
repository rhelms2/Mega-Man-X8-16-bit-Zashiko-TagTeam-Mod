extends X8OptionButton

var current_option = 9

func setup() -> void :
	if CharacterManager.new_game:
		Configurations.erase("BossBattleTheme")
		CharacterManager.new_game = false
		CharacterManager._save()
	set_bosssong(get_bosssong())
	display(current_option)

func increase_value() -> void :
	current_option += 1
	if current_option > 9:
		current_option = 0
	set_bosssong(current_option)
	display(current_option)

func decrease_value() -> void :
	current_option -= 1
	if current_option < 0:
		current_option = 9
	set_bosssong(current_option)
	display(current_option)

func set_bosssong(value) -> void :
	Configurations.set("BossBattleTheme", value)
	current_option = value
	Event.emit_signal("music_changed")

func get_bosssong():
	if Configurations.exists("BossBattleTheme"):
		return Configurations.get("BossBattleTheme")
	return 9

func display(_current_option):
	if _current_option == 0:
		display_value("OFF_VALUE")
	elif _current_option == 1:
		display_value("X1")
	elif _current_option == 2:
		display_value("X2")
	elif _current_option == 3:
		display_value("X3")
	elif _current_option == 4:
		display_value("X4")
	elif _current_option == 5:
		display_value("X5")
	elif _current_option == 6:
		display_value("X6")
	elif _current_option == 7:
		display_value("X7")
	elif _current_option == 8:
		display_value("X8")
	elif _current_option == 9:
		display_value("X1 - X8")
	else:
		display_value("OFF_VALUE")
