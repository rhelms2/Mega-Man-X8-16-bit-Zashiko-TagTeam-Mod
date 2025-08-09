extends NewAbility

export var dash_speed := 210.0
export var duration := 0.5
var quantity := 1
var ground_dash := false
var able := true
onready var stage = AbilityStage.new(self)
onready var physics = Physics.new(get_parent())
onready var animation = AnimationController.new($"../animatedSprite", self)
onready var dash_particles: Particles2D = $dash_particles
onready var dash: AudioStreamPlayer2D = $dash_sound

var pressed_direction := 0

func _StartCondition() -> bool:
	if not able or is_pressing_wrong_direction():
		return false
	if physics.is_on_floor():
		return true
	return quantity > 0 and not is_moving_too_fast()

func _Setup() -> void:
	animation.play("dash")
	dash.play_rp(0.035)
	quantity -= 1
	physics.set_horizontal_speed_towards_facing_direction(dash_speed)
	ground_dash = physics.is_on_floor()
	if ground_dash:
		dash_particles.emitting = true
	physics.set_vertical_speed(0)

func _Update(delta) -> void:
	if animation.has_finished_last():
		animation.play_once("dash_loop")
	if physics.is_on_floor():
		ground_dash = true
	else:
		timer += delta
		dash_particles.emitting = false
	if ground_dash:
		physics.process_gravity(delta)

func _EndCondition() -> bool:
	return timer > duration

func _Interrupt() -> void:
	dash_particles.emitting = false

func is_opposite_direction(dir : int) -> bool:
	return physics.get_facing_direction() != dir

func is_pressing_wrong_direction() -> bool:
	if pressed_direction == 0:
		return false
	return pressed_direction != physics.get_facing_direction()

func is_moving_too_fast() -> bool:
	return abs(physics.get_horizontal_speed()) > 150
	
func _on_land() -> void:
	quantity = 1

func _on_dash_jump() -> void:
	able = false

func reset_dash_jump() -> void:
	able = true

func _on_move_right() -> void:
	pressed_direction = 1
	if is_executing() and is_pressing_wrong_direction():
		EndAbility()

func _on_move_left() -> void:
	pressed_direction = -1
	if is_executing() and is_pressing_wrong_direction():
		EndAbility()
	
func _on_release_right() -> void:
	if pressed_direction == 1:
		pressed_direction = 0
		
func _on_release_left() -> void:
	if pressed_direction == -1:
		pressed_direction = 0

func _on_release() -> void:
	if is_executing():
		EndAbility()


func _on_Ride_stop(_ability_name) -> void:
	pass # Replace with function body.
