extends AnimatedSprite

var activated: = false

func _ready() -> void :
	get_parent().connect("body_entered", self, "_on_finish_line_body_entered")

func _on_finish_line_body_entered(_body: Node) -> void :
	if not activated:
		activated = true
		play("finish")
		frame = 0
	pass
