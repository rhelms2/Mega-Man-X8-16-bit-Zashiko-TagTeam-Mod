extends ColorRect

export  var menu: NodePath
export  var background: NodePath
export  var duration: float = 0.25

onready var main = get_node(menu)

var bg
var transitioning: bool = false
var tween: SceneTreeTween

signal finished


func _ready() -> void :
	if background:
		bg = get_node(background)

func FadeIn() -> void :
	transitioning = true
	reset_tween()
	tween.tween_property(self, "color", Color.black, duration)
	tween.tween_callback(self, "show_menu")
	tween.tween_property(self, "color", Color(0, 0, 0, 0), duration)
	tween.tween_callback(self, "finish")

func FadeOut() -> void :
	transitioning = true
	reset_tween()
	tween.tween_property(self, "color", Color.black, duration)
	tween.tween_callback(self, "hide_menu")
	tween.tween_property(self, "color", Color(0, 0, 0, 0), duration)
	tween.tween_callback(self, "finish")

func SoftFadeOut() -> void :
	transitioning = true
	reset_tween()
	tween.tween_property(self, "color", Color.black, duration * 4)
	tween.tween_property(self, "color", Color.black, duration * 4)
	tween.tween_callback(self, "finish")

func reset_tween() -> void :
	if tween:
		tween.kill()
	tween = create_tween()

func show_menu() -> void :
	main.set_visible(true)
	if bg:
		bg.set_visible(true)

func hide_menu() -> void :
	main.set_visible(false)
	if bg:
		bg.set_visible(false)

func finish() -> void :
	emit_signal("finished")
	transitioning = false
