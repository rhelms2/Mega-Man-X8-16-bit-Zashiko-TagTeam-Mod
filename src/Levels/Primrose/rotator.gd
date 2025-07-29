extends Node
export  var active: = true
export  var debug_logs: = false
onready var parent = get_parent()

func _ready() -> void :
	Event.listen("stage_rotate", self, "on_rotate_stage")
	Event.listen("unrotate", self, "unrotate")
	
func on_rotate_stage() -> void :
	if active:
		Log("Stage Rotate. Sending signal...")
		Event.emit_signal("rotate_exception", parent)
		if parent is NewBox:
			Event.emit_signal("rotate_inclusion", parent.get_node("animatedSprite"))

func unrotate() -> void :
	if active:
		parent.rotation_degrees = 0

func Log(message) -> void :
	if debug_logs:
		print(parent.name + ".rotator: " + str(message))
