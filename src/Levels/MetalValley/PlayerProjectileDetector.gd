extends Area2D
export  var active: = true

const projectiles = ["FireDash", "FlameBurner", "Enkoujin"]
export  var projectile_name: = "FireDash"
signal projectile_detected

func _on_area2D_body_entered(body: Node) -> void :
	if active:
		for word in projectiles:
			if word in body.name:
				emit_signal("projectile_detected")
