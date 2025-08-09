extends Node2D

onready var medium: Sprite = $medium
onready var medium_2: Sprite = $medium2
onready var big: Sprite = $big

func _physics_process(delta: float) -> void :
	big.rotation_degrees += 10 * delta
	medium.rotation_degrees -= 10 * delta
	medium_2.rotation_degrees -= 10 * delta
