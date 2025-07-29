extends Node

export  var disable_or_deactivate: bool = false
export  var make_invisible: bool = false
export  var fade_out: bool = false
export  var delete_after_fade: bool = false
export  var stop_emitting: bool = false
export  var queue_free: bool = false
export  var on_rotation_end: bool = false
export  var undo_on_rotation_end: bool = true

onready var parent = get_parent()


func _ready() -> void :
	if on_rotation_end:
		Event.listen("stage_rotate_end", self, "on_rotate_stage")
	else:
		Event.listen("stage_rotate", self, "on_rotate_stage")
		if undo_on_rotation_end:
			Event.listen("stage_rotate_end", self, "on_rotate_end")

func on_rotate_stage() -> void :
	if queue_free:
		parent.queue_free()
		return
	if parent.name == "Remains":
		if not parent.emitting:
			return
	if parent.has_method("disable"):
		parent.disable()
	elif parent.has_method("deactivate"):
		parent.deactivate()
	if stop_emitting:
		parent.emitting = false
	if make_invisible:
		parent.visible = false
	if fade_out:
		var tween: SceneTreeTween = parent.create_tween()
		tween.set_pause_mode(SceneTreeTween.TWEEN_PAUSE_PROCESS)
		tween.tween_property(parent, "modulate:a", 0.0, 0.25)
		if delete_after_fade:
			var delete_method: = "queue_free"
			if parent.has_method("restart"):
				delete_method = "restart"
			if parent.has_method("destroy"):
				delete_method = "destroy"
			tween.tween_callback(parent, delete_method)

func on_rotate_end() -> void :
	if parent.has_method("disable"):
		parent.enable()
	elif parent.has_method("deactivate"):
		parent.activate()
	if stop_emitting:
		parent.emitting = true
	if make_invisible:
		parent.visible = true
	if fade_out:
		var tween: SceneTreeTween = parent.create_tween()
		tween.set_pause_mode(SceneTreeTween.TWEEN_PAUSE_PROCESS)
		tween.tween_property(parent, "modulate:a", 1.0, 0.25)
