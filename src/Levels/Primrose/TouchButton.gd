extends AnimatedSprite

export  var active: = true
export  var degrees_to_rotate: = 90.0
var time_to_reactivate: = 3.0
onready var press: AudioStreamPlayer2D = $press

func ready() -> void :
	Event.listen("stage_rotate_end", self, "deactivate")
	Event.listen("stage_rotate", self, "activate")

func _on_area2D_body_entered(_body: Node) -> void :
	if active:
		press.play()
		Event.emit_signal("rotate_stage_in_degrees", degrees_to_rotate, get_parent())
		deactivate()
		Tools.timer(time_to_reactivate, "reactivate", self)

func deactivate() -> void :
	active = false
	play("down")

func reactivate() -> void :
	active = true
	play("up")
