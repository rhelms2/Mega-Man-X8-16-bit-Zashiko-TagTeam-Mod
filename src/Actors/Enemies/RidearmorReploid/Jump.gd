extends NewAbility
onready var skill := $".."
var able_to_jump = true
signal started
signal cooldown_finished
signal ended

func get_character():
	return $"../.."

func _Setup() -> void:
	able_to_jump = false
	emit_signal("started")
	skill.set_vertical_speed(-skill.jump_velocity)
	skill.force_movement(skill.horizontal_velocity/2)
	skill.play_animation("jump")
	Tools.timer(1.5,"able_to_jump_again",self)

func _Update(delta) -> void:
	if character.get_vertical_speed() > 0:
		skill.play_animation_once("fall")
	
	if timer > 0.1 and character.is_on_floor():
		EndAbility()
		
func _Interrupt() -> void:
	skill.play_animation("recover")
	emit_signal("ended")
	
func able_to_jump_again() -> void:
	able_to_jump = true

func able_to_walk_again() -> void:
	emit_signal("cooldown_finished")

func _StartCondition() -> bool:
	if able_to_jump:
		return ._StartCondition()
	else:
		return false
