extends Light2D

onready var tween: = TweenController.new(self, false)


func _on_Capsule_lightning() -> void :
	visible = true
	tween.attribute("energy", 0.0, 1.0)
