extends Node2D

var iceblocks: Array
var active: = false

func _ready() -> void :
	for child in get_children():
		if child is KinematicBody2D:
			iceblocks.append(child)


func _on_IceStarter_body_entered(body: Node) -> void :
	if not active:
		active = true
		var start_time: = 0.1
		var interval: = 0.33
		for block in iceblocks:
			Tools.timer(start_time, "activate", block)
			start_time += interval
