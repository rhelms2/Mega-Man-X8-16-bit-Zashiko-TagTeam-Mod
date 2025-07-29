extends Node2D
class_name WallEnemyAlarmAwareness

func _ready() -> void :
	Event.listen("alarm", self, "on_alarm")
	Event.listen("turn_off_alarm", self, "on_alarm_off")
	
	pass

func on_alarm() -> void :
	
	get_parent().append_behaviour_to_on_enter_screen_event("../BlockPassage")

func on_alarm_off() -> void :
	get_parent().on_enter_screen.clear()
	pass
