extends InstantDeathArea

export  var detect_charged: bool = true

signal freeze
signal small_ice(projectile)


func _on_area2D_body_entered(body: Node) -> void :
	if active:
		if body.is_in_group("Player"):
			bodies.append(body.get_parent())
			set_physics_process(true)
		else:
			if CharacterManager.game_mode > 0:
				return
				
			if detect_charged and body.name == "DriftDiamondCharged":
				emit_signal("freeze")
				body.deflect(self)
			elif "DriftDiamond" in body.name and not body.name == "DriftDiamondCharged":
				emit_signal("small_ice", body)
				body.deflect(self)
			elif "IceGattling" in body.name:
				emit_signal("small_ice", body)
				body.deflect(self)
			elif "Hyouryuushou" in body.name:
				emit_signal("small_ice", body)
				body.deflect(self)

func _on_area2D_body_exited(body: Node) -> void :
	bodies.erase(body.get_parent())
	if bodies.size() == 0:
		set_physics_process(false)
