extends NewAbility

onready var physics: = Physics.new($"..")
onready var stage: = AbilityStage.new(self)
onready var animation: = AnimationController.new($"../animatedSprite")
onready var step: AudioStreamPlayer2D = $step
onready var tween: = TweenController.new(self)

func _ready() -> void :
	
	pass

func _Update(delta: float) -> void :
	physics.process_gravity(delta * 6.5)
	
	if stage.is_initial() and timer > get_time_between_steps():
		animation.play("walk_step")
		step()
		stage.next()
		
	elif stage.currently_is(1) and timer > get_time_between_steps():
		animation.play("walk_step2")
		step()
		stage.go_to_stage(0)

func _Interrupt() -> void :
	emit_signal("stop")
	physics.set_horizontal_speed(0)

func get_time_between_steps() -> float:
	if distance_from_player() > 100:
		return 0.45
	
	return 0.55

func get_pursuit_speed() -> float:
	return - 250.0

func step_sound_and_screenshake() -> void :
	step.play()
	Event.emit_signal("screenshake", 0.7)

func distance_from_player() -> float:
	return abs(global_position.x - GameManager.get_player_position().x)

func step() -> void :
	tween.method("set_horizontal_speed", 0.0, get_pursuit_speed(), 0.2, physics)
	tween.add_callback("step_sound_and_screenshake")
	tween.add_method("set_horizontal_speed", get_pursuit_speed(), 0.0, 0.2, physics)
