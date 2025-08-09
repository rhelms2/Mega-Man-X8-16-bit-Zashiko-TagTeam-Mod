extends Weapon

func position_shot(shot) -> void:
	shot.transform = global_transform
	shot.projectile_setup(owner.get_facing_direction(), owner.shot_position.position, abs(owner.get_actual_speed()))
