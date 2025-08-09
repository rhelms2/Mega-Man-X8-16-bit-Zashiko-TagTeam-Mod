extends Area2D

export  var disabled: = false
signal prepare
signal activated

func _on_body_entered(_body: Node) -> void :
	if not disabled:
		disabled = true
		Event.emit_signal("screenshake", 1)
		emit_signal("prepare")
		Tools.timer_p(0.6, "emit_signal", self, ["activated"])
		
