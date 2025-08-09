extends NewAbility

export var upward_time := 0.25
export var hover_time := 0.6
export var horizontal_speed := 90.0
export var jump_speed := 120.0
export var hover_speed := 50.0
var hover_fuel := hover_time
var current_jump_speed := 90.0
var current_horizontal_speed := 90.0
var stopping := false

onready var stage = AbilityStage.new(self)
onready var physics = Physics.new(get_parent())
onready var animation = AnimationController.new($"../animatedSprite", self)
onready var tween = TweenController.new(self)

onready var jump: AudioStreamPlayer2D = $jump_sound
onready var rise: AudioStreamPlayer2D = $rise

signal dash_jump

func _StartCondition() -> bool:
	return physics.is_on_floor() or hover_fuel > 0

func _Setup() -> void:
	if not physics.is_on_floor():
		stage.go_to_stage(1)
	hover_fuel -= 0.1
	handle_horizontal_speed()
	physics.set_horizontal_speed(0)
	animation.play("jump")
	current_jump_speed = jump_speed
	stopping = false

func handle_horizontal_speed() -> void:
	current_horizontal_speed = horizontal_speed
	var h_speed = abs(physics.get_horizontal_speed())
	if h_speed > horizontal_speed:
		current_horizontal_speed = h_speed
		emit_signal("dash_jump")
	
func _Update(delta) -> void:
	if stage.is_initial():
		jump()
	
	elif stage.on_next():
		hover(delta)

# warning-ignore:function_conflicts_variable
func jump() -> void:
	if timer < upward_time:
		jump.play_once()
		physics.set_vertical_speed(-current_jump_speed)
	else:
		if physics.get_vertical_speed() < 0:
			physics.set_vertical_speed(-current_jump_speed)
			if not stopping:
				tween.attribute("current_jump_speed",0)
				stopping = true
		else:
			stage.next()

func hover(delta) -> void:
	hover_fuel -= delta
	if hover_fuel > 0:
		rise.play_once()
		animation.play_once("jump_loop")
		physics.set_vertical_speed(-hover_speed)
	else:
		EndAbility()

func _EndCondition() -> bool:
	return timer > 0.1 and physics.is_on_floor()

func _Interrupt() -> void:
	if hover_fuel > 0:
		rise.stop()
	tween.reset()

func _on_move_right() -> void:
	if is_executing():
		physics.set_direction(1)
		physics.set_horizontal_speed_towards_facing_direction(current_horizontal_speed)
	
func _on_move_left() -> void:
	if is_executing():
		physics.set_direction(-1)
		physics.set_horizontal_speed_towards_facing_direction(current_horizontal_speed)
		
func _on_move_release() -> void:
	if is_executing():
		physics.set_horizontal_speed(0)

func _on_release() -> void:
	if is_executing():
		physics.set_vertical_speed(0)
		EndAbility()

func _on_land() -> void:
	jump.stop()
	hover_fuel = hover_time
