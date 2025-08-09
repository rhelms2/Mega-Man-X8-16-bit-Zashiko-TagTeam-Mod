extends Charge


func get_default_charge_button() -> String:
	return "fire_emulated"

func get_charge_pressed() -> bool:
	return get_action_pressed("fire_emulated")

func set_current_charge_button() -> void :
	if get_action_pressed("fire_emulated"):
		charge_button = "fire_emulated"
	elif get_action_pressed("fire_emulated"):
		charge_button = "fire_emulated"

func get_charge_just_pressed() -> bool:
	return get_action_just_pressed("fire_emulated")

func get_charge_released() -> bool:
	return not get_action_pressed("fire_emulated")
	
func _EndCondition() -> bool:
	return false



func get_action_just_pressed(_element) -> bool:
	return just_pressed
func get_action_pressed(_element) -> bool:
	return pressed
func get_action_just_released(_element) -> bool:
	return just_released

var just_pressed: = false
var just_released: = false
var pressed: = false

func _input(event: InputEvent) -> void :
	if event.is_action_pressed("fire_emulated"):
		
		if pressed:
			just_pressed = false
		pressed = true
	elif event.is_action_released("fire_emulated"):
		just_released = true if pressed else false
		pressed = false
		just_pressed = false
