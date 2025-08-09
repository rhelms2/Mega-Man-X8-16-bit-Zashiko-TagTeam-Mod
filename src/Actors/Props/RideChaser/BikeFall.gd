extends BikeJump

onready var jump: Node2D = $"../Jump"
var played_jump_feedback_sound := false

func _Setup():
	Event.emit_signal("jump")
	extra_vertical_speed = get_vertical_speed()
	fullspeed_time = 0
	slowdown_time = 0
	stopped_input = false
	speed_at_jump_start = abs(get_actual_speed())
	update_bonus_horizontal_speed()
	#character.set_vertical_speed(extra_vertical_speed -jump_plus_ground_velocity) 
	played_jump_feedback_sound = false
#	character.disable_floor_snap()

func get_shot_adust_position() -> Vector2:
	return  Vector2(-5, -15)

func _Update(_delta: float) -> void:
	delta = _delta
	process_gravity(_delta, 700)
	deaccelerate(deacceleration, minimum_speed)
	process_speed()
	force_movement_regardless_of_direction(get_actual_speed())
	handle_jump_feedback_sound_on_ramps()
	if character.get_vertical_speed() > 0:
		character.enable_floor_snap()

func handle_jump_feedback_sound_on_ramps():
	if not played_jump_feedback_sound:
		if character.get_vertical_speed() < -jump.jump_velocity:
			if Input.is_action_just_pressed("jump"):
				jump.play_sound_on_initialize()
				played_jump_feedback_sound = true

func play_animation_on_initialize():
	play_animation_once(animation)

func _StartCondition() -> bool:
	if not character.is_on_floor():
		return true
	return false

func play_sound_on_initialize():
	pass

func process_speed():
	deaccelerate(deacceleration, minimum_speed)
	if is_braking():
		brake(brake_speed)
	elif should_stop():
		stop()
