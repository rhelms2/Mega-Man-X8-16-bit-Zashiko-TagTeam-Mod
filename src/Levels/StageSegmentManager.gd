extends Node2D

export var active := true
export var debug_logs := false
export var extra_rooms : Array
export var VisibilityNotifierObject : PackedScene


func _ready() -> void:
	if active:
		for segment in get_children():
			add_visibility_enabler(segment)
		for path in extra_rooms:
			add_visibility_enabler(get_node(path))
			

func add_visibility_enabler(segment) -> void:
	segment.visible = false
	
	var vn = VisibilityNotifierObject.instance()
	vn.debug_logs = debug_logs
	vn.global_position = segment.global_position
	segment.add_child(vn)
	
