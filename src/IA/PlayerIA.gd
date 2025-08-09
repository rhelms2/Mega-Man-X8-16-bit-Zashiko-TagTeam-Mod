extends Node

var weapon : Resource
onready var x: KinematicBody2D = $"../X"

func initialize():
	if GameManager.player == null:
		GameManager.set_player(x)
	GameManager.player.equip_parts("hermes_arms")
	call_deferred("emit_signal_weapon")

func emit_signal_weapon():
	Event.emit_signal("select_weapon",weapon)
	

func delayed_start() -> void:
	weapon.input_sequence.call_actions(self)
	define_camera_right_limit(weapon.input_sequence.limit)

func start():
	#Event.emit_signal("intro_x")
	Tools.timer(1,"delayed_start",self)

func emulate_press(key, press := false) -> void:
	
	var event = InputEventAction.new()
	event.action = key
	event.pressed = press
	Input.parse_input_event(event)

func define_camera_right_limit(value) -> void:
	$"../StateCamera".custom_limits_right = value

func _on_weapon_defined(_weapon) -> void:
	weapon = _weapon
	call_deferred("initialize")
