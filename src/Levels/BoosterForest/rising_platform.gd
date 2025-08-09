extends StaticBody2D
class_name RisingPlatform

export var tiles := 10
export var speed := 0.25
export var screenshake := false
onready var tween = TweenController.new(self,false)
var max_position := false
var activated := false

signal started
signal reset
signal at_max

func _on_Button_button_press() -> void:
	if not max_position:
		rise()
	else:
		lower()

func rise() -> void:
	if not max_position:
		emit_signal("started")
		tween.attribute("position:y",position.y - tiles * 16.0 , speed * tiles)
		tween.set_sequential()
		tween.add_callback("reached_max_position")

func lower() -> void:
	if max_position:
		emit_signal("started")
		tween.attribute("position:y",position.y + tiles * 16.0 , speed * tiles)
		tween.set_sequential()
		tween.add_callback("reached_start_position")

func reached_max_position() -> void:
	if screenshake:
		Event.emit_signal("screenshake",0.7)
	emit_signal("reset")
	emit_signal("at_max")
	max_position = true
	
func reached_start_position() -> void:
	if screenshake:
		Event.emit_signal("screenshake",0.7)
	emit_signal("reset")
	max_position = false
	
func _on_ElevatorStarter_body_entered(_body: Node) -> void:
	if not activated:
		activated = true
		rise()
		Tools.timer(6,"lower_on_time",self)

func lower_on_time() -> void:
	lower()
	activated = false

func _on_area2D_body_entered(_body: Node) -> void:
	_on_ElevatorStarter_body_entered(_body)
