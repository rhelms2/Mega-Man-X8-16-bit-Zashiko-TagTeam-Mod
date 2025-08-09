extends Node2D

onready var tween := TweenController.new(self,false)

func _ready() -> void:
	tween.attribute("modulate:a",0.8,.5)
	tween.add_callback("queue_free")
