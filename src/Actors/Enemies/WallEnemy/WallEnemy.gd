extends Enemy

var alarm: = false

func _ready() -> void :
	Event.connect("alarm", self, "on_alarm")
	Event.connect("alarm_done", self, "on_alarm_done")
	
func on_alarm() -> void :
	alarm = true
func on_alarm_done() -> void :
	alarm = false

func _on_SearchLight_alarm_activated() -> void :
	emit_signal("external_event")
	pass


	


func _on_visibilityNotifier2D_screen_entered() -> void :
	if alarm:
		emit_signal("external_event")
		pass
	pass
