extends X8OptionButton

onready var sprite: AnimatedSprite = $"animatedSprite"

func setup() -> void :
	dim()

func _on_focus_entered() -> void :
	._on_focus_entered()

func _on_focus_exited() -> void :
	._on_focus_exited()
	dim()

func on_press() -> void :
	pass

func process_inputs() -> void :
	pass

func display() -> void :
#	if not GameManager.equip_hearts:
#		value.text = " "
#		self_modulate.a = 0.7
#	else:
#		value.text = "x" + str(get_heart_count())
#		self_modulate.a = 1
	pass
