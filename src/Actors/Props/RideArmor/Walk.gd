extends NewAbility

export var walk_speed := 90.0
var sound_played := false

onready var physics = Physics.new(get_parent())
onready var animation = AnimationController.new($"../animatedSprite", self)
onready var step: AudioStreamPlayer2D = $step

func _Setup() -> void:
	animation.play("walk")

func _Update(_delta) -> void:
	physics.process_gravity(_delta)
	physics.set_horizontal_speed_towards_facing_direction(walk_speed)
	play_steps_sounds()

func play_steps_sounds() -> void:
	if animation.is_between(1,1) or animation.is_between(6,6):
		if not sound_played:
			step.play_rp(0.06)
			sound_played = true
	else:
		sound_played = false
	

func _Interrupt() -> void:
	physics.set_horizontal_speed(0)

func _on_move_right() -> void:
	if is_executing():
		physics.set_direction(1)
	
func _on_move_left() -> void:
	if is_executing():
		physics.set_direction(-1)

func _on_release() -> void:
	if is_executing():
		EndAbility()
