extends EnemyDeath
onready var collision_shape_2d: CollisionShape2D = $"../collisionShape2D"
export  var test: = false

func extra_actions_at_death_start() -> void :
	collision_shape_2d.set_deferred("disabled", true)
	if test:
		$"../Box/collisionShape2D".set_deferred("disabled", true)
