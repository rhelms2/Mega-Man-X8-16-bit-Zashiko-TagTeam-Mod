extends Node
export  var active: = true
export  var return_time_after_rotation_end: = 0.1
onready var parent = get_parent()

func _ready() -> void :
	Event.listen("stage_rotate", self, "on_rotate_stage")
	Event.listen("stage_rotate_end", self, "on_rotate_end")
	
func on_rotate_stage() -> void :
	if active:
		parent.set_deferred("monitoring", false)

func on_rotate_end() -> void :
	if active:
		Tools.timer(return_time_after_rotation_end, "set_monitoring_to_true", self)
	
func set_monitoring_to_true() -> void :
	parent.set_deferred("monitoring", true)
	
