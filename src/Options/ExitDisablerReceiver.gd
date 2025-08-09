extends Node


func _ready() -> void :
	if not "finished_intro" in GameManager.collectibles:
		disable()

func disable() -> void :
	$"..".visible = false
	pass
