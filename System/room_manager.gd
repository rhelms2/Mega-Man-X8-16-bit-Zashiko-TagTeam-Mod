extends Node2D

onready var visibility_notifier: = $visibilityNotifier2D

var exclude: = [
	"Portal", 
	"Portal2"
	]

func _ready():
	visibility_notifier.connect("screen_entered", self, "_show_room")
	visibility_notifier.connect("screen_exited", self, "_hide_room")
	visible = false
	_set_childs_physics(false)

func _show_room():
	visible = true
	_set_childs_physics(true)
	
func _hide_room():
	visible = false
	_set_childs_physics(false)

func _set_childs_physics(_active: bool):
	for child in get_children():
		if child.name in exclude:
			return
			
		if child.has_method("set_physics_process"):
			child.set_physics_process(_active)
		if child.has_method("set_process"):
			child.set_process(_active)
		if "active" in child:
			child.active = _active
		
		if child.get_child_count() > 0:
			for grandchild in child.get_children():
				if grandchild.has_method("set_physics_process"):
					grandchild.set_physics_process(_active)
				if grandchild.has_method("set_process"):
					grandchild.set_process(_active)
				if "active" in grandchild:
					grandchild.active = _active


func _remove_room():
	queue_free()
