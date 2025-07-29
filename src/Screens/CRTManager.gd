extends Node

const crt: PackedScene = preload("res://src/Screens/CRT.tscn")

var fullscreen: bool = false

var light
var strong
var crt_shader: CanvasLayer


func _ready() -> void :
	crt_shader = crt.instance()
	get_parent().call_deferred("add_child", crt_shader)
	Tools.timer(0.1, "late_initialization", self)

func late_initialization() -> void :
	light = crt_shader.get_node("Light")
	strong = crt_shader.get_node("Strong")
	Configurations.listen("value_changed", self, "on_value_change")
	crt_changed()

func on_value_change(key) -> void :
	if key == "CRT":
		crt_changed()

func crt_changed() -> void :
	strong.visible = false
	light.visible = false
	match Configurations.get("CRT"):
		null:
			pass
		0:
			pass
		1:
			light.visible = true
		2:
			strong.visible = true
