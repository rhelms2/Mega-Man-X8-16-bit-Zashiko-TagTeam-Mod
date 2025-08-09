extends MediumBuster
class_name ChargedBuster
var original_spawn_position : Vector2
const has_deflectable := true

func position_setup(spawn_point:Vector2, direction:int):
	original_spawn_position = spawn_point
	position.x = position.x + (spawn_point.x - 10)  * direction
	position.y = position.y + spawn_point.y -1
	facing_direction = direction

func _on_visibilityNotifier2D_screen_exited() -> void:
	countdown_to_destruction = 0.01

func emit_hit_particle():
	.emit_hit_particle()
	hit_particle.scale = direction

func deflect(_d) -> void:
	pass

