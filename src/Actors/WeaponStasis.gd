extends EventAbility

signal interrupted

var impeded := false

func _ready() -> void:
	if active:
		character.listen("end_weapon_stasis",self,"stop")
		character.listen("cutscene_deactivate",self,"impede")

func stop(_forcer = null):
	if executing:
		EndAbility()

func impede() -> void:
	impeded = true
	stop()

func _Setup() -> void:
	Log("Weapon took Control")
	#character.stop_listening_to_inputs()
	character.set_horizontal_speed(0)
	character.set_vertical_speed(0)

func _Update(_delta: float) -> void:
	pass

func _Interrupt():
	character.set_horizontal_speed(0)
	character.set_vertical_speed(0)
	emit_signal("interrupted")
	if not impeded:
		character.activate()
	impeded = false

func _EndCondition() -> bool:
	return false

func is_high_priority() -> bool:
	return true
