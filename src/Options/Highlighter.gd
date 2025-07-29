extends Control
class_name LightGroup

export  var objects_to_light: Array
export  var focus_group: Array
export  var idle_color: Color = Color.dimgray
export  var focus_color: Color = Color.white
export  var focus_multiplier: float = 2.0
export  var press_multiplier: float = 3.0

var focus_nodes: Array
var nodes: Array
var lit: bool = false
var tween: SceneTreeTween

func _ready() -> void :
	call_deferred("save_nodes")
	call_deferred("dim_objects")

func save_nodes() -> void :
	for path in objects_to_light:
		nodes.append(get_node(path))
	for path in focus_group:
		focus_nodes.append(get_node(path))

func dim_objects() -> void :
	on_no_focus()
	lit = false
	reset_tween()
	for node in nodes:
		tween.tween_property(node, "modulate", idle_color, 0.1)

func light_objects() -> void :
	lit = true
	reset_tween()
	for node in nodes:
		node.modulate = focus_color * focus_multiplier
		node.modulate.a = 1
		tween.tween_property(node, "modulate", focus_color, 0.1)

func _process(_delta: float) -> void :
	for node in focus_nodes:
		if node.has_focus():
			on_focused_node(node)
			if not lit:
				light_objects()
			return
	if lit:
		dim_objects()

func on_focused_node(_focus) -> void :
	pass
func on_no_focus() -> void :
	pass

func reset_tween() -> void :
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_parallel()
