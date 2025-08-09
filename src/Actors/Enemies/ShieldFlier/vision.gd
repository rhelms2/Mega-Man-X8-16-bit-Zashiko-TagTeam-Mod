extends Area2D

var fliped := false
onready var shield_flier: KinematicBody2D = $"../.."

func _ready() -> void:
	pass


func _on_ShieldFlier_new_direction(dir) -> void:
	if not fliped and shield_flier.spawn_direction == -1:
		fliped = true
		scale.x = scale.x * -1
	pass # Replace with function body.
