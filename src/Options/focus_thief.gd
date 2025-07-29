extends Button
onready var mouse_focus_blocker: ColorRect = $mouse_focus_blocker

func _process(_delta: float) -> void :
	mouse_focus_blocker.visible = has_focus()
