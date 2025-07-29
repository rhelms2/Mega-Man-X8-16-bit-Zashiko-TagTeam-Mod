extends X8TextureButton

onready var text: Label = $text
onready var actionname: Label = $"../actionname"
onready var pick: AudioStreamPlayer = $"../pick"
onready var cancel: AudioStreamPlayer = $"../cancel"

var waiting_for_input: bool = false
var original_event: InputEvent
var timer: float = 0.0
var old_text: String = ""
var doubled_input

signal waiting
signal updated_event


func _ready() -> void :
	InputManager.connect("double_check", self, "check_for_doubles")
	InputManager.connect("double_detected", self, "double_warning")

func check_for_doubles(_new_button_text, _action):
	pass
	
func double_warning(_double_button_text, _action):
	pass

func _process(delta: float) -> void :
	if timer >= 0.01:
		timer += delta
		text.self_modulate.a = inverse_lerp( - 1, 1, sin(timer * 6))
	if timer > 5:
		
		menu.emit_signal("unlock_buttons")
		grab_focus()
		waiting_for_input = false
		timer = 0
		set_text(old_text)
		text.self_modulate.a = 1.0

func _input(event: InputEvent) -> void :
	if not has_focus():
		return
	if event is InputEventKey and event.scancode == KEY_ESCAPE:
		cancel.play()
		clear_binding()
		return
	if event is InputEventMouseMotion:
		return
	elif timer > 0.25:
		if name == "key" and event is InputEventMouseButton and not event.is_pressed():
			pick.play()
			set_new_action_event(event)
		elif name == "key" and event is InputEventKey and not event.is_pressed():
			pick.play()
			set_new_action_event(event)
		elif name == "joypad" and event is InputEventJoypadButton and not event.is_pressed():
			pick.play()
			set_new_action_event(event)
		elif name == "joypad" and event is InputEventJoypadMotion:
			if abs(event.axis_value) > 0.35:
				pick.play()
				set_new_action_event(event)

func clear_binding():
	InputMap.action_erase_events(get_parent().action)
	InputManager.set_new_action_event(get_parent().action, null, original_event)
	set_text("(NOT SET)")
	emit_signal("updated_event")
	waiting_for_input = false
	timer = 0
	text.self_modulate.a = 1.0
	menu.emit_signal("unlock_buttons")
	grab_focus()

func set_new_action_event(event) -> void :
	InputManager.set_new_action_event(get_parent().action, event, original_event)
	emit_signal("updated_event")
	waiting_for_input = false
	timer = 0
	text.self_modulate.a = 1.0
	menu.emit_signal("unlock_buttons")
	grab_focus()

func on_press() -> void :
	if timer == 0:
		.on_press()
		old_text = get_text()
		set_text("...")
		timer = 0.01
		emit_signal("waiting")
		menu.emit_signal("lock_buttons")
		focus_mode = Control.FOCUS_ALL
		grab_focus()

func set_text(txt) -> void :
	InputManager.emit_signal("double_check", txt, $"../actionname".text)
	text.text = txt

func get_text() -> String:
		return text.text
