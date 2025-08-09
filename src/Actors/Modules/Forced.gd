extends EventAbility

func _ready() -> void:
	if active:
		character.listen("stop_forced_movement",self,"stop")

func stop(_forcer = null):
	EndAbility()

func _Setup() -> void:
	Log("Lost Control")
	character.stop_listening_to_inputs()
	character.set_horizontal_speed(0)
	character.set_vertical_speed(0)

func _Update(_delta: float) -> void:
	pass

func _Interrupt():
	character.activate()

func _EndCondition() -> bool:
	return false

func is_high_priority() -> bool:
	return true
