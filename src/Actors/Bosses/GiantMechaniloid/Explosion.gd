extends Particles2D

func _on_EnemyDeath_ability_start(_ability) -> void:
	emitting = true


func _on_GiantMechaniloid_death() -> void:
	emitting = false
	pass # Replace with function body.
