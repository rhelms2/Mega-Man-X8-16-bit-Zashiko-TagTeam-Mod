extends Area2D
class_name FlamableBarrierProjectileDetector

export  var active: = true

export var projectiles = ["FireDash", "FlameBurner", "Enkoujin"]

signal projectile_detected

func _on_area2D_body_entered(body: Node) -> void :
	if active:
		for word in projectiles:
			if word in body.name:
				emit_signal("projectile_detected")
