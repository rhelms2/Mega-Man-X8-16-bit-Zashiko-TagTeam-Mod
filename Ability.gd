class_name Ability
extends BaseAbility

export var actions : Array
var action := "action name"
export var animation : String
export var sound : AudioStream
var input_activation := 0.1
var input := 0.0
var last_pressed_input:= ""
var last_time_pressed := 0.0
var has_let_go_of_input := false

func check_for_event_errors() -> void:
	if actions.size() == 0:
		push_error("WARNING: " +get_parent().name + "."+ name + " has no actions. Did you forget to append an 'Event' action?")

func Should_Execute() -> bool:
	if active:
		if check_all_actions_for_input() or should_execute_on_hold():
			if not conflicting_abilities():
				input = get_action_value()
				return true
	return false

func should_execute_on_hold() -> bool:
	return false

func Initialize():
	.Initialize()
	play_sound_on_initialize()
	play_animation_on_initialize()
	adjust_shot_position_on_initialize()

func Finalize() -> void:
	has_let_go_of_input = false
	.Finalize()

func BeforeEveryFrame(delta: float) -> void:
	.BeforeEveryFrame(delta)
	input = get_action_value()
	check_for_let_go_of_input()

func CheckForPressed() -> bool:
	if is_always_input():
		return true
	if not is_event_based():
		for element in actions:
			if character.get_action_pressed(element):
				action = element
				return true
	return false

func is_event_based():
	for element in actions:
		if element == "Event":
			action = "Event"
			return true
	return false

func is_always_input():
	if actions.size() == 0:
			action = "Always"
			return true

func _physics_process(_delta: float) -> void:
	if active:
		if has_input_buffer():
			save_last_time_pressed()

func save_last_time_pressed():
	for element in actions:
		if character.get_action_just_pressed(element):
			last_pressed_input = element
			last_time_pressed = get_time()

func check_all_actions_for_input() -> bool:
	if is_event_based():
		return false
	if is_always_input():
		return true
	if not should_execute_on_hold():
		for element in actions:
			if get_action_just_pressed(element):
				action = element
				return true
	else:
		for element in actions:
			if get_action_pressed(element):
				action = element
				return true
	
	if has_input_buffer() and was_used_recently():
		for element in actions:
			if get_action_pressed(element):
				if was_pressed_recently(element):
					return true
			
	return false

func has_input_buffer() -> bool:
	return get_activation_leeway_time() > 0

func get_activation_leeway_time() -> float:
	return 0.0

func get_action_just_pressed(element) -> bool:
	if should_always_listen_to_inputs():
		return Input.is_action_just_pressed(element)
	else:
		return character.get_action_just_pressed(element)
	
func get_action_pressed(element) -> bool:
	if should_always_listen_to_inputs():
		return Input.is_action_pressed(element)
	else:
		return character.get_action_pressed(element)

func get_action_just_released(element) -> bool:
	if should_always_listen_to_inputs():
		return Input.is_action_just_released(element)
	else:
		return character.get_action_just_released(element)

func should_always_listen_to_inputs():
	return false

func was_used_recently() -> bool:
	return get_time() > last_time_used + get_activation_leeway_time() * 1000

func was_pressed_recently(_action: String) -> bool:
	if _action == last_pressed_input:
		return (get_time() - last_time_pressed) / 1000 < get_activation_leeway_time()
	return false

func Has_time_ran_out() -> bool:
	print_debug("Using unimplemented method")
	return false
	
func stop_sound() -> void:
	if audio != null:
		audio.stop()

func play_sound_on_initialize():
	if sound:
		play_sound(sound)
	
func play_animation_on_initialize():
	if animation:
		play_animation(animation)

func play_animation(anim : String):
	character.play_animation(anim)
	
func play_animation_once(anim : String):
	character.play_animation_once(anim)

func get_pressed_direction() -> int:
	return character.get_pressed_axis()

func Is_Input_Happening() -> bool:
	return input > 0

func get_action_value() -> float:
	if action == "Always" or action == "Event":
		return 1.0
	if action == "action name":
		#Log("Possible error, no action name defined")
		return 1.0
	return character.get_action_strength(action)

func check_for_let_go_of_input():
	if input == 0:
		has_let_go_of_input = true

func adjust_shot_position_on_initialize():
	if get_shot_adust_position() != Vector2.ZERO:
		adjust_shot_position(get_shot_adust_position())

func get_shot_adust_position() -> Vector2: #suposed to be overriden by actions that need adjustment
	return Vector2.ZERO

func adjust_shot_position (shot_adjustment):
	_commandList.Add(AddVectorCMD.new(character.shot_position,shot_adjustment))
	
func set_camera_offset(horizontal_offset := 32.0, duration := 0.5) -> void:
	Event.emit_signal("camera_offset",Vector2(horizontal_offset * character.get_facing_direction(),0),duration)

func disable_camera_offset() -> void:
	Log("Disabling camera offset")
	set_camera_offset(0)
