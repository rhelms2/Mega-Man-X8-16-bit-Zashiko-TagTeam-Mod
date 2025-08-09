extends PrimaryShot


func get_action_just_pressed(_element) -> bool:
	if just_pressed:
		just_pressed = false
		return true
	return false
func get_action_pressed(_element) -> bool:
	return pressed
func get_action_just_released(_element) -> bool:
	return just_released

func set_current_weapon(weapon):
	current_weapon = weapon
	update_character_palette()
	Log("Changed Weapon to " + current_weapon.name)
	Event.emit_signal("changed_weapon", current_weapon)
	next_shot_ready = false

var just_pressed: = false
var just_released: = false
var pressed: = false

func _input(event: InputEvent) -> void :
	if event.is_action_pressed("fire_emulated"):
		just_pressed = true
		pressed = true
		just_released = false
	elif event.is_action_released("fire_emulated"):
		just_released = true
		pressed = false
		just_pressed = false
