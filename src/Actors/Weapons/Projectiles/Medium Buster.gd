extends Lemon
class_name MediumBuster

func _on_visibilityNotifier2D_screen_exited() -> void:
	countdown_to_destruction = 0.01

func call_screenexit_event():
	pass
	
func hit(target):
	if target.damage(damage,self) > 0:
		hit_time = 0.01
		emit_hit_particle()
		countdown_to_destruction = 0.01
		disable_projectile_visual()
		remove_from_group("Player Projectile")
		call_screenexit_event()
		if target.is_in_group("Enemies"):
			Event.emit_signal("charge_hit_enemy")


func deflect(_body) -> void:
	if is_in_group("Player Projectile"):
		.deflect(_body)
