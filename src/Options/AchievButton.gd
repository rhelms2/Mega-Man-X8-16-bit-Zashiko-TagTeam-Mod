extends X8OptionButton

func setup() -> void :
	set_show_achievements(get_show_achievements())

func increase_value() -> void :
	set_show_achievements( not get_show_achievements())

func decrease_value() -> void :
	set_show_achievements( not get_show_achievements())

func set_show_achievements(value: bool) -> void :
	Configurations.set("ShowAchievements", value)
	display_show_achievements()

func get_show_achievements():
	if Configurations.exists("ShowAchievements"):
		return Configurations.get("ShowAchievements")
	return true

func display():
	pass

func display_show_achievements():
	if Configurations.get("ShowAchievements"):
		display_value("ON_VALUE")
	else:
		display_value("OFF_VALUE")
