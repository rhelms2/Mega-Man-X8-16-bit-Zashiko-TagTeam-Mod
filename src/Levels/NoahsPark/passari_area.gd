extends Area2D
class_name passarin_area
onready var passarins: Particles2D = $Passarins
var emitted: = false

func _ready() -> void :
	emitted = false
	pass

func _on_area2D_body_entered(_body: Node) -> void :
	if not emitted:
		passarins.emitting = true
		emitted = true
