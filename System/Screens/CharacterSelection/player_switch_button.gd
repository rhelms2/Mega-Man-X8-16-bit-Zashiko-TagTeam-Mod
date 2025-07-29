extends X8TextureButton

onready var char_container = $"../characters/panel/char_container"
export  var direction = "right"

func on_start() -> void :
	pass

func _on_focus_entered() -> void :
	._on_focus_entered()
	

func _on_focus_exited() -> void :
	._on_focus_exited()

func on_press() -> void :
	char_container.emit_signal("switch_character", direction)
	pass
