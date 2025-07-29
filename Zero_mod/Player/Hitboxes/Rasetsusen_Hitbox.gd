extends SaberZeroHitbox
class_name RasetsusenZeroHitbox

var inner_radius: float = 16.0


func set_hitbox(position: Vector2, radius: float):
	var shape = CircleShape2D.new()
	shape.radius = radius
	collision_shape.shape = shape
	deflection_shape.shape = shape
	self.position = position

func hit(target):
	if active:
		var dist = global_position.distance_to(target.global_position)
		if dist < inner_radius:
			return
		
		if saber_rehit != 0:
			if "saber_rehit" in target:
				if target.saber_rehit <= 0:
					if target is BossDamage:
						target.saber_rehit = saber_rehit * 2
						Event.emit_signal("saber_has_hit_boss")
					else:
						target.saber_rehit = saber_rehit
					target.damage(damage, self)
					Event.emit_signal("saber_has_hit")
			else:
				target.damage(damage, self)

func _on_area2D_body_entered(body: Node) -> void :
	if active:
		if body.is_in_group("Enemies") or body.is_in_group("Bosses") or body.is_in_group("Player"):
			return
		if body.is_in_group("Enemy Projectile") or body.is_in_group("Player Projectile"):
			for exception in exceptions:
				if body.name.begins_with(exception):
					return

			var dist = global_position.distance_to(body.global_position)
			if dist < inner_radius:
				return

			if deflectable:
				if body.active:
					react(body)
