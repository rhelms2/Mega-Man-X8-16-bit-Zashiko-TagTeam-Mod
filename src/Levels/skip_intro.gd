extends EventAbility

export var beam_speed := 420.0
var descending := false
onready var animatedSprite = get_parent().get_node("animatedSprite")
onready var thunder = get_node("audioStreamPlayer2")

func _ready() -> void:
	Event.emit_signal("x_appear")

func _Setup():
	call_deferred("EndAbility")

func _Interrupt():
	character.activate()
	Event.emit_signal("gameplay_start")

func _EndCondition() -> bool:
	return false

func is_high_priority() -> bool:
	return true
