extends Area2D

export  var disabled: = false
signal activated

func _on_body_entered(_body: Node) -> void :
	if not disabled:
		disabled = true
		emit_signal("activated")
