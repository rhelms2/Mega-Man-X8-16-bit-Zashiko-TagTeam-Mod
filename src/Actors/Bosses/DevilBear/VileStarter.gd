extends Node

export var threshold := 200.0
var total_health := -1.0
onready var devilbear: KinematicBody2D = $".."
onready var vile: AnimatedSprite = $"../vile"
onready var vile_riding: CollisionShape2D = $"../DamageOnTouch/area2D/VileRiding"

func _ready() -> void:
	Tools.timer(0.1,"get_health",self)


func get_health() -> void:
	total_health = devilbear.current_health

func _on_took_damage() -> void:
	if has_taken_enough_damage():
		Event.emit_signal("vile_eject",devilbear)
		vile.visible = false
		vile_riding.set_deferred("disabled",true)
		queue_free()
	
func has_taken_enough_damage() -> bool:
	return total_health - devilbear.current_health >= threshold


