extends Node2D

signal crush
signal crush_end
export  var debug: = false
export  var active: = true

func activate() -> void :
	active = true
	
func deactivate() -> void :
	active = false

func _on_crush_area_body_entered(body: Node) -> void :
	if active:
		if body.name == "X":
			emit_signal("crush")
			Tools.timer(0.1, "emit_crush_end", self)
			deactivate()
		elif body.name == "Zero":
			if body.get_node("animatedSprite").animation != "youdantotsu":
				emit_signal("crush")
				Tools.timer(0.1, "emit_crush_end", self)
				deactivate()
		elif body.name == "Axl":
			emit_signal("crush")
			Tools.timer(0.1, "emit_crush_end", self)
			deactivate()
		else:
			if body.has_method("crush"):
				body.crush()

func emit_crush_end():
	emit_signal("crush_end")
