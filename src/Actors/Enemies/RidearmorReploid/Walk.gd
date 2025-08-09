extends NewAbility
onready var skill := $".."
var able_to = true
var sound_played = false
var double_check := false

onready var animation := AnimationController.new($"../../animatedSprite")

signal started
signal step

func get_character():
	return $"../.."

func _Setup() -> void:
	skill.turn_and_face_player()
	skill.screenshake(0.7)
	skill.play_animation("walk")
	Tools.timer(0.032,"start_walking",self)
	emit_signal("started")

func _Interrupt() -> void:
	if character.is_on_floor():
		skill.play_animation("fall")
	else:
		skill.play_animation("recover")

func start_walking() -> void:
	if executing:
		skill.force_movement(skill.horizontal_velocity)

func able_to_walk_again() -> void:
	able_to = true
	
func _StartCondition() -> bool:
	if able_to:
		return ._StartCondition()
	else:
		return false

func _Update(_delta) -> void:
	play_steps_sounds()
	if not is_player_in_front() and not double_check:
		double_check = true
		Tools.timer(0.35,"double_check_player_in_front",self)

func double_check_player_in_front() -> void:
	double_check = false
	if not is_player_in_front():
		EndAbility()

func play_steps_sounds() -> void:
	if animation.is_between(1,1) or animation.is_between(6,6):
		if not sound_played:
			emit_signal("step")
			sound_played = true
	else:
		sound_played = false

func is_player_in_front() -> bool:
	return skill.is_player_in_front()

func _EndCondition() -> bool:
	return not character.is_on_floor()

func _on_Punch_started() -> void:
	able_to = false

func _on_Jump_started() -> void:
	able_to = false
