extends Node2D

onready var road: = $continuous_road
onready var road2: = $continuous_road2

func _physics_process(delta: float) -> void :
	road.position.x += - 160 * delta
	road2.position.x += - 160 * delta
	
	if road.position.x < - 192 * 2:
		road.position.x = (192 * 2) - 2
	if road2.position.x < - 192 * 2:
		road2.position.x = (192 * 2) - 2
