extends RigidBody2D
onready var projectile: = $".."
export  var deflect_particle: NodePath
export  var break_guards: = false
export  var break_guard_damage = 1

func deactivate() -> void :
	$collisionShape2D.set_deferred("disabled", true)
func activate() -> void :
	$collisionShape2D.set_deferred("disabled", false)

func deflect(_body) -> void :
	if not projectile.ending:
		projectile._OnDeflect()

func hit(_d = null) -> void :
	pass
func leave(_d = null) -> void :
	pass

	
	
func get_facing_direction() -> int:
	return projectile.get_facing_direction()
