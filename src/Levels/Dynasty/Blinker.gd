extends Node

export  var blinkers: Array
export  var parts: Array

func _ready() -> void :
	for c in blinkers:
		parts.append(get_node(c))

func blink() -> void :
	for part in parts:
		part.modulate = Color(15, 15, 15, 1)
		Tools.tween(part, "modulate", Color.white, 0.064)
