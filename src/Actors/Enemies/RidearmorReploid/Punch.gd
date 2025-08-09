extends NewAbility
onready var skill := $".."
onready var animated_sprite: AnimatedSprite = $"../../animatedSprite"

var able_to = true
signal initialized
signal started
signal cooldown_finished

func get_character():
	return $"../.."

func _Setup() -> void:
	emit_signal("initialized")
	able_to = false
	skill.turn_and_face_player()
	skill.decay_speed()
	skill.play_animation("punch_1")
	Tools.timer(0.15,"activate_hitbox",self)
	animated_sprite.connect("animation_finished",self,"EndAbility",[],4)# warning-ignore:return_value_discarded
	Tools.timer(1.5,"able_to_walk_again",self)

func _Interrupt() -> void:
	skill.play_animation("recover")

func able_to_walk_again() -> void:
	able_to = true
	emit_signal("cooldown_finished")

func activate_hitbox() -> void:
	emit_signal("started")

func _StartCondition() -> bool:
	if able_to:
		return ._StartCondition()
	else:
		return false
