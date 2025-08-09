extends KinematicBody2D

signal disabled


func _ready() -> void :
	pass

func energize() -> void :
	emit_signal("disabled")
