extends Node2D

func _ready() -> void :
	Event.listen("pitch_black_energized", self, "queue_free")
