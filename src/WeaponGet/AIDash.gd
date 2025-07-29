extends Dash


func get_action_just_pressed(_element) -> bool:
	if just_pressed:
		just_pressed = false
		return true
	return false
func get_action_pressed(_element) -> bool:
	return pressed
func get_action_just_released(_element) -> bool:
	return just_released

var just_pressed: = false
var just_released: = false
var pressed: = false

func _input(event: InputEvent) -> void :
	if event.is_action_pressed(actions[0]):
		just_pressed = true
		pressed = true
		just_released = false
	elif event.is_action_released(actions[0]):
		just_released = true
		pressed = false
		just_pressed = false
