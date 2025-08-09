extends EnemyDeath

export var colliders : Array

func extra_actions_at_death_start() -> void:
	for each in colliders:
		get_node(each).set_deferred("disabled", true)
