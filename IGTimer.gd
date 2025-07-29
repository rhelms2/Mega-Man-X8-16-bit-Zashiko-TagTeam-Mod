extends Node

onready var section: String = get_parent().name


func _physics_process(delta: float) -> void :
	if get_tree().paused:
		IGT.add_time("Paused",delta)
	else:
		IGT.add_time(section, delta)
