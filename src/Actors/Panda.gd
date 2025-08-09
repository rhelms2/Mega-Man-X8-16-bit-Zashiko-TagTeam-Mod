extends Enemy
class_name Panda # Boss

 
signal intro_concluded
 
signal damage_reduction
var timer := 0.0

func raycast(target_position : Vector2) -> Dictionary:
	var space_state = get_world_2d().direct_space_state
	return space_state.intersect_ray(global_position, target_position, [self], collision_mask)

func is_colliding_with_wall(wallcheck_distance := 32, _vertical_correction := 0) -> int:
	if raycast(Vector2(global_position.x + wallcheck_distance, global_position.y)):
		return 1
	elif raycast(Vector2(global_position.x - wallcheck_distance, global_position.y)):
		return -1
	return 0

func set_invulnerability(time:float):
	if time > 0:
		invulnerability = time
		add_vertical_speed(0)
func _on_area2D_body_entered(_body: Node) -> void:
	if _body.is_in_group("Player Projectile"):
		_body.hit(self)

func _on_area2D_body_exited(body: Node) -> void:
	if body.is_in_group("Player Projectile"):
		body.leave(self)

