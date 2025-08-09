extends Node

onready var fade: Sprite = $fade

func _ready() -> void :
	goto_next_scene()

func goto_next_scene() -> void :
	get_tree().change_scene("res://src/Title/DisclaimerScreen.tscn")
