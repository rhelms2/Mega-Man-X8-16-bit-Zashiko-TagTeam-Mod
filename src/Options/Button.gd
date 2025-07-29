extends TextureButton
class_name X8TextureButton

export  var idle_color: Color = Color.dimgray
export  var focus_color: Color = Color.white
export  var focus_multiplier: float = 2.0
export  var press_multiplier: float = 3.0
export (NodePath) var menu_path

var tween: SceneTreeTween
var original_y: float = rect_position.y
var silent: bool = false
var menu


func start_button() -> void :
	if menu_path:
		menu = get_node(menu_path)
		connect_lock_signals(menu)

func _ready() -> void :
	if menu_path:
		menu = get_node(menu_path)
		connect_lock_signals(menu)

func connect_lock_signals(_menu) -> void :
	if _menu:
		if not menu:
			menu = _menu
		_menu.connect("unlock_buttons", self, "enable")
		_menu.connect("lock_buttons", self, "disable")

func enable() -> void :
	focus_mode = Control.FOCUS_ALL

func disable() -> void :
	focus_mode = Control.FOCUS_NONE

func _on_focus_entered() -> void :
	play_sound()
	flash()

func flash() -> void :
	modulate = focus_color * focus_multiplier
	modulate.a = 1.0
	reset_tween()
	tween.tween_property(self, "modulate", focus_color, 0.1)

func play_sound() -> void :
	if not silent and menu:
		menu.play_choice_sound()
	silent = false

func silent_focus() -> void :
	silent = true
	_on_focus_entered()

func _on_focus_exited() -> void :
	dim()

func dim() -> void :
	reset_tween()
	tween.tween_property(self, "modulate", idle_color, 0.1)

func half_dim() -> void :
	reset_tween()
	tween.tween_property(self, "modulate", (focus_color + idle_color) / 2, 0.1)

func _on_pressed() -> void :
	if focus_mode == 0:
		return
	on_press()

func on_press() -> void :
	strong_flash()

func strong_flash() -> void :
	modulate = focus_color * press_multiplier
	modulate.a = 1.0
	reset_tween()
	tween.tween_property(self, "modulate", focus_color, 0.35)

func _on_mouse_entered() -> void :
	call_deferred("grab_focus")

func reset_tween() -> void :
	if tween:
		tween.kill()
	tween = create_tween()

func _on_mouse_exited() -> void :
	pass
