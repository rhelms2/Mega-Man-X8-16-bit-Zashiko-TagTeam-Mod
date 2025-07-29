extends EnemyShield

signal destroyer_hit

func _ready() -> void :
	pass
	
func handle_break_guard(projectile) -> void :
	if breakable and projectile.break_guards:
		call_deferred("emit_guard_break")
	elif "destroyer" in projectile:
		emit_signal("destroyer_hit")
		deactivate()
	else:
		emit("shield_hit")
		emit_signal("shield_hit", projectile)

func handle_damage_over_time(projectile) -> void :
	if "continuous_damage" in projectile and projectile.continuous_damage:
		if character is Actor:
			projectile.hit(character)
