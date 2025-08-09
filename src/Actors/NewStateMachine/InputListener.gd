extends Node

export  var every_frame: bool = false
export  var inputs: Array

var pressing: bool = false
var waiting_for_unpause: Array

signal pressed
signal just_pressed
signal released


func _ready() -> void :
	pause_mode = Node.PAUSE_MODE_PROCESS
	Event.listen("unpause", self, "on_unpause")

func set_process_input(b: bool) -> void :
	if not b:
		release_button_press()
	.set_process_input(b)

func _input(event: InputEvent) -> void :
	if every_frame:
		set_process_input(false)
		return
	if not get_tree().paused:
		for action in inputs:
			handle_input(event, action)

func handle_input(event: InputEvent, action: String) -> void :
	if event.is_action_pressed(action):
		if not pressing:
			emit_signal("just_pressed")
			pressing = true

	else:
		if get_tree().paused:
			buffer("released")
			pressing = false
		else:
			emit_signal("released")
			pressing = false

func _physics_process(_delta: float) -> void :
	if every_frame:
		for action in inputs:
			if Input.is_action_pressed(action):
				if not pressing:
					emit_signal("just_pressed")
				pressing = true
			else:
				if pressing:
					emit_signal("released")
				pressing = false
	if pressing:
		emit_signal("pressed")

func buffer(signal_name) -> void :
	if not signal_name in waiting_for_unpause:
		waiting_for_unpause.append(signal_name)

func on_unpause() -> void :
	if waiting_for_unpause.size() > 0:
		call_buffered_signals()

func call_buffered_signals() -> void :
	for signal_name in waiting_for_unpause:
		emit_signal(signal_name)
	waiting_for_unpause.clear()

func release_button_press() -> void :
	pressing = false
	emit_signal("released")
	waiting_for_unpause.clear()
