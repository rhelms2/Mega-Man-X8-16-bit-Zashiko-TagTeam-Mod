extends Node2D
onready var explosion: Particles2D = $explosion
onready var remains: Particles2D = $remains
onready var bamboo: Node2D = $".."

func _on_Health_zero_health() -> void:
	if bamboo.stage.get_current() >= 3:
		explosion.emitting = true
		remains.emitting = true


func activate() -> void:
	explosion.emitting = true
	remains.emitting = true
