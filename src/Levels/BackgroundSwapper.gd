extends Area2D
class_name BackgroundSwapper

export var debug := false
export var _backgrounds : Array
export var _bg_to_activate : NodePath
onready var bg_to_activate := get_node(_bg_to_activate)
var backgrounds : Array

func _ready() -> void:
	for bg_path in _backgrounds:
		backgrounds.append(get_node(bg_path))

func _on_area2D_body_entered(_body: Node) -> void:
	if debug:
		print_debug(name + ": body entered " + _body.name)
	deactivate_bg()
	activate_bg()
	if debug:
		print_debug(name + ": activated " + bg_to_activate.name)

func deactivate_bg() -> void:
	for bg in backgrounds:
		bg.visible = false

func activate_bg() -> void:
	bg_to_activate.visible = true
	

func _on_BackgroundSwap_body_exited(_body: Node) -> void:
	pass
