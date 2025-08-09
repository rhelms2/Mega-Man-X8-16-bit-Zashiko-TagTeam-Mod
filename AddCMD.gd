extends Command
class_name AddToVector2CMD
var reference : Actor
var value := 0.0

func _init(ref, add_value) -> void:
	reference = ref
	value = add_value

func Execute():
	reference.bonus_velocity.x = reference.bonus_velocity.x + value

func Undo():
	reference.bonus_velocity.x = reference.bonus_velocity.x - value
