extends Node

onready var start: AnimatedSprite = $"../start"
onready var body_1: AnimatedSprite = $"../body1"
onready var body_2: AnimatedSprite = $"../body2"
onready var body_3: AnimatedSprite = $"../body3"
onready var parts = [start,body_1,body_2,body_3]

func blink() -> void:
	for part in parts:
		part.modulate = Color(15,15,15,1)
		Tools.tween(part,"modulate",Color.white,0.064)
