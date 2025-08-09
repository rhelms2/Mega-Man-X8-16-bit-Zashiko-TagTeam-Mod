extends ChargedBuster
export var auxiliary_projectiles : PackedScene

func projectile_setup(dir : int, position : Vector2, _launcher_velocity := 0.0):
	.projectile_setup(dir, position)
	call_deferred("create_auxiliary_shots",dir)

func create_auxiliary_shots(dir) -> void:
	var aux_shot = auxiliary_projectiles.instance()
	var aux_shot2 = auxiliary_projectiles.instance()
	get_tree().root.add_child(aux_shot,true)
	get_tree().root.add_child(aux_shot2,true)
	aux_shot.global_position = global_position
	aux_shot2.global_position = global_position

	var aux_velocity = horizontal_velocity
	aux_shot.go_up(aux_velocity)
	aux_shot2.go_down(aux_velocity)
	if dir > 0:
		aux_shot.go_right(aux_velocity)
		aux_shot2.go_right(aux_velocity)
	else:
		aux_shot.go_left(aux_velocity)
		aux_shot2.go_left(aux_velocity)
	aux_shot.update_facing_direction()
	aux_shot2.update_facing_direction()
	
