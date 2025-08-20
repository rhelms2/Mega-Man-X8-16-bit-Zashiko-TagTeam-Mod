extends FlamableBarrierProjectileDetector


func _on_area2D_body_entered(body: Node) -> void :
	if GameManager.player is PlayerZeroX8 and active:
		for word in projectiles:
			if word in body.name and "K-Knuckle" in GameManager.player.saber_node.current_weapon.name:
				emit_signal("projectile_detected")


func _on_MechaStarter_body_entered(body):
	emit_signal("projectile_detected")
