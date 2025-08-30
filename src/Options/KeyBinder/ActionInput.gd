extends LightGroup

onready var action_name: Label = $actionname
onready var key: = $key
onready var joypad: = $joypad
var action

func setup(_action, readname, menu) -> void :
	key.connect_lock_signals(menu)
	joypad.connect_lock_signals(menu)
	action = _action
	action_name.text = tr(readname)
	var _s = key.connect("updated_event", self, "get_inputs_and_set_names")
	_s = joypad.connect("updated_event", self, "get_inputs_and_set_names")
	get_inputs_and_set_names(action)

func get_inputs_and_set_names(_action = action) -> void :
	var inputs = InputMap.get_action_list(_action)
	for button in inputs:
		var named_keyboard: = false
		var named_joypad: = false
		if button is InputEventJoypadButton and not named_joypad:
			joypad.set_text(Input.get_joy_button_string(button.button_index))
			joypad.original_event = button
			named_joypad = true
		elif button is InputEventJoypadMotion and not named_joypad:
			joypad.set_text(Input.get_joy_axis_string(button.axis))
			joypad.original_event = button
			named_joypad = true
		if button is InputEventKey and not named_keyboard:
			key.set_text(button.as_text())
			key.original_event = button
			named_keyboard = true
		elif button is InputEventMouseButton and not named_keyboard:
			key.set_text("Mouse" + str(button.button_index))
			key.original_event = button
			named_keyboard = true
	
