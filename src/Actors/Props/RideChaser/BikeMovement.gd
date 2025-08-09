extends Movement
class_name BikeMovement

var delta = 0.016

func _Setup():
	update_bonus_horizontal_only_conveyor()

func play_animation_on_initialize():
	if animation:
		play_animation(animation)

func get_actual_speed() -> float:
	return character.get_actual_speed()

func set_actual_speed(speed: float) -> void:
	character.set_actual_speed(speed)

func add_actual_speed(speed: float) -> void:
	character.add_actual_speed(speed)

func _StartCondition() -> bool:
	return true
	
func _Update(_delta: float) -> void:
	delta = _delta
	if character.is_colliding_with_ground():
		process_gravity(delta)
	process_speed()
	force_movement_regardless_of_direction(get_actual_speed())
	#update_facing_direction()

func process_speed():
	pass


func deaccelerate(deacceleration : float, minimum_speed) -> void:
	Log("Deaccelerating")
	if is_deaccelerating_right(minimum_speed):
			add_actual_speed( -(deacceleration * delta))
	elif is_deaccelerating_left(minimum_speed):
			add_actual_speed(deacceleration * delta)


func stop() -> void:
	Log("Stopping")
	if get_actual_speed() != 0:
		set_actual_speed (get_actual_speed() * 0.85)

func should_stop() -> bool:
	return get_actual_speed() < 95 and get_actual_speed() > -95

func is_deaccelerating(minimum_speed) -> bool:
	if get_pressed_direction() != 0:
		return false
	return is_deaccelerating_right(minimum_speed) or is_deaccelerating_left(minimum_speed)

func is_deaccelerating_right(minimum_speed : float) -> bool:
	return moving_right() and get_actual_speed() > minimum_speed

func is_deaccelerating_left(minimum_speed : float) -> bool:
	return moving_left() and get_actual_speed() < minimum_speed * -1

func moving_right() -> bool:
	return get_actual_speed() > 0
	
func moving_left() -> bool:
	return get_actual_speed() < 0

func _EndCondition() -> bool:
	return false

func _Interrupt() -> void:
	pass

func is_accelerating() -> bool:
	return is_accelerating_right() or is_accelerating_left()

func is_accelerating_right() -> bool:
	return get_pressed_direction() > 0 and character.get_facing_direction() > 0 and get_actual_speed() < horizontal_velocity

func is_accelerating_left() -> bool:
	return get_pressed_direction() < 0 and character.get_facing_direction() < 0 and get_actual_speed() > horizontal_velocity * -1

func accelerate(acceleration : float) -> void:
	Log("Accelerating")
	if is_accelerating_right():
		add_actual_speed ( acceleration * delta)
	elif is_accelerating_left():
		add_actual_speed( - (acceleration * delta))

func play_animation(anim : String) -> void:
	character.play_animation_once(anim)

func brake(break_speed : float) -> void:
	Log("Braking")
	if is_braking_right():
		add_actual_speed ( break_speed * delta)
		if moving_right():
			set_actual_speed(0)
	elif is_braking_left():
		add_actual_speed( - (break_speed * delta))
		if moving_left():
			set_actual_speed(0)

func is_braking() -> bool:
	return is_braking_left() or is_braking_right()

func is_braking_right() -> bool:
	return get_pressed_direction() > 0 and moving_left()
	
func is_braking_left() -> bool:
	return get_pressed_direction() < 0 and moving_right()

func play_sound_on_initialize():
	if sound:
		play_sound(sound, false)

func EndAbility() -> void: #override
	Log("Ending")
	Finalize() 
	character.remove_from_executing_list(self)
	#character.enable_floor_snap()
	emit_signal("ability_end", self)
