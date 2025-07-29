extends Area2D

export  var disabled: = false
signal activated

func _on_body_entered(_body: Node) -> void :
	if not disabled:
		disabled = true
		emit_signal("activated")
		GameManager.start_cutscene()
		Tools.timer(1.5, "show_warning", self)
	
func show_warning() -> void :
	Event.emit_signal("show_warning")
	Tools.timer(3.0, "spawn_vile", self)

func spawn_vile() -> void :
	Event.emit_signal("vile_door_closed")
	
func prepare_boss() -> void :
	Event.emit_signal("vile_door_open")
