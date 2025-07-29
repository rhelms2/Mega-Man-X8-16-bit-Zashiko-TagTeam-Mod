extends AttackAbility

var current_vertical_speed: = 0.0
var jump_timne: = 0.7

func _Setup() -> void :
	force_movement(0)
	current_vertical_speed = - 200
	var tween = create_tween()
	tween.tween_property(self, "current_vertical_speed", 0.0, jump_timne).set_trans(Tween.TRANS_CUBIC)

func _Update(_delta: float) -> void :
	set_vertical_speed(current_vertical_speed)
	if timer > jump_timne:
		play_animation("idle")
		EndAbility()
