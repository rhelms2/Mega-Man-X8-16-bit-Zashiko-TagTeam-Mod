extends AttackAbility

const projectile_distance_from_wall := 90
export var optic_gun : PackedScene

func _Setup() -> void:
	turn_and_face_player()
	play_animation("attack2_prepare")

func _Update(delta) -> void:
	process_gravity(delta)
	
	if attack_stage == 0 and timer > 0.5:
		play_animation("attack2")
		create_optic_gun()
		next_attack_stage()
	
	elif attack_stage == 1 and timer > 0.5:
		play_animation("attack2_end")
		next_attack_stage()
	
	elif attack_stage == 2 and has_finished_last_animation():
		EndAbility()

func create_optic_gun() -> void:
	var o = instantiate(optic_gun)
	o.global_position.y += 8
	o.global_position.x += 24 * get_facing_direction()
	o.stop_positions = get_laser_stop_positions()
	o.starting_direction = get_facing_direction()

func get_laser_stop_positions() -> Array:
	var left_wall = get_wall_position(-1) + projectile_distance_from_wall
	var right_wall = get_wall_position(1) - projectile_distance_from_wall
	if get_facing_direction() > 0:
		return [right_wall,left_wall]
	return [left_wall,right_wall]
