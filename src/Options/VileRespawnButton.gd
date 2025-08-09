extends X8OptionButton
onready var parent_button: Control = $".."

func setup() -> void :
	set_vile_spawn(get_vile_spawn())

func increase_value() -> void :
	set_vile_spawn( not get_vile_spawn())

func decrease_value() -> void :
	set_vile_spawn( not get_vile_spawn())

func set_vile_spawn(value: bool) -> void :
	Configurations.set("VileRespawn", value)
	Event.emit_signal("set_vile_respawn", value)
	display_vile_spawn()

func get_vile_spawn():
	if Configurations.exists("VileRespawn"):
		return Configurations.get("VileRespawn")
	return true

func display():
	pass

func display_vile_spawn():
	if Configurations.get("VileRespawn"):
		display_value("ON_VALUE")
	else:
		display_value("OFF_VALUE")

func _on_initialize() -> void :
	if GameManager.has_beaten_the_game():
		parent_button.visible = true
	else:
		parent_button.visible = false
