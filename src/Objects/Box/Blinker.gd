extends Node
export  var flash_parent: = true
export  var parts: Array
onready var parent: = get_parent()

func blink() -> void :
	if flash_parent:
		flash_tween(parent)
	for part in parts:
		flash_tween(part)

func flash_tween(object) -> void :
		object.modulate = Color(15, 15, 15, 1)
		Tools.tween(object, "modulate", Color.white, 0.048)
	
