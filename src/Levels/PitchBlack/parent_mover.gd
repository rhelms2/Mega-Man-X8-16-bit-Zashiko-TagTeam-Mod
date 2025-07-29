extends Node

onready var new_parent: CanvasLayer = $"../../../Scenery/canvasLayer"
onready var deathshock: Node2D = $".."

func move() -> void :
	Tools.timer(0.1, "reparent", self)
	pass

func reparent() -> void :
	deathshock.get_parent().remove_child(deathshock)
	new_parent.call_deferred("add_child", deathshock)
	pass
