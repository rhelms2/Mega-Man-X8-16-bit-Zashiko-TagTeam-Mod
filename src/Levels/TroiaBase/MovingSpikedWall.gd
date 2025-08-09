extends Node2D
onready var spiked_wall: Node2D = $SpikedWall

var activated: = false

func _on_activator_body_entered(_body: Node) -> void :
	if not activated:
		activate()

func activate() -> void :
	activated = true
	var tween = create_tween()
	tween.tween_property(spiked_wall, "position:x", 260.0, 10.0)
