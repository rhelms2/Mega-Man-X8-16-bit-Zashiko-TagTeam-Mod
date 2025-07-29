extends Node

onready var section: String = "IGT_" + get_parent().name


func _physics_process(delta: float) -> void :
	GlobalVariables.add(section, delta)
