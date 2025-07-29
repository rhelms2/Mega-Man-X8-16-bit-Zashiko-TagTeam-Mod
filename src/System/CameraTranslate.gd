extends CameraMode

func activate(_target) -> void :
	.activate(_target)
	translate()

func translate() -> void :
	var tween = create_tween()
	tween.tween_property(camera, "global_position", get_target(), 1.25)
	tween.tween_callback(self, "deactivate")
	camera.emit_start_translate()

func deactivate() -> void :
	camera.emit_finish_translate()
	camera.current_mode = null

func _on_camera2D_start_translate(target_position) -> void :
	activate(target_position)
