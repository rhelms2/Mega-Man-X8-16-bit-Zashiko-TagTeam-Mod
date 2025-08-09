extends Movement
class_name IdleZero


func _ready() -> void :
	character.get_node("animatedSprite").connect("animation_finished", self, "_on_animatedSprite_animation_finished")

func _StartCondition() -> bool:
	if character.is_on_floor():
		return true
	return false

func _Setup() -> void :
	character.set_horizontal_speed(0)
	deactivate_low_jumpcasts()
	if character.get_animation() != "saber_recover":
		character.play_animation("recover")

func _Update(_delta: float) -> void :
	character.set_direction(get_pressed_direction())
	update_bonus_horizontal_only_conveyor()

func _EndCondition() -> bool:
	if not character.is_on_floor():
		return true
	return false

func recover() -> void :
	if executing:
		character.play_animation("recover")
		character.animatedSprite.set_frame(0)

func _on_animatedSprite_animation_finished() -> void :
	pass
