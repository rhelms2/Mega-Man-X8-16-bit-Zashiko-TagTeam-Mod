extends Node
onready var parent = get_parent()

func _ready() -> void :
	Event.listen("stage_rotate", self, "on_rotate_stage")
	
func on_rotate_stage() -> void :
	parent.queue_free()
