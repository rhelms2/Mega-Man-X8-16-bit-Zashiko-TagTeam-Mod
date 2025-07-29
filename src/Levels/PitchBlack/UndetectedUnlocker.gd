extends Node

export  var achievement: Resource

var detected: = false
var lit: = false

func _ready() -> void :
	Event.connect("alarm", self, "on_alarm")
	Event.connect("pitch_black_energized", self, "on_lit")

func on_lit():
	
	lit = true

func on_alarm():
	
	detected = true

func fire_achievement() -> void :
	
	if not detected and not lit:
		Achievements.unlock(achievement.get_id())
