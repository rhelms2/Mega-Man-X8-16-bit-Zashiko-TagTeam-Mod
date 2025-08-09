extends Label

onready var idle_color: Color = Color.dimgray
onready var focus_color: Color = Color.white


func _on_focus_entered() -> void :
	modulate = focus_color

func _on_focus_exited() -> void :
	modulate = idle_color
