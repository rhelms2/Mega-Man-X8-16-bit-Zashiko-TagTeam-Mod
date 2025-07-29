extends Node
class_name TouchControls

onready var touch_controls: PackedScene = preload("res://System/Android/AndroidControls.tscn")

var _HUD
var excluded_controllers: Array = [
	"uinput-fpc", 
	"uinput-fortsense", 
	"uinput-hidraw", 






]


func _ready() -> void :
	_HUD = get_parent().get_node("Hud")


	if touch_controls != null:
		var touch_instance = touch_controls.instance()
		
		_HUD.add_child(touch_instance)
		queue_free()


















func check_for_controller() -> bool:
	var joypads = Input.get_connected_joypads()
	for joypad_id in joypads:
		var joypad_name = Input.get_joy_name(joypad_id)
		
		if joypad_name in excluded_controllers:
			
			return false
		else:
			
			return true
	
	return false
