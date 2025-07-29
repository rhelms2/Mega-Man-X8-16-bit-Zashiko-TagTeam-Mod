extends PizzaJuggleAndMove


func set_projectile() -> void:
	pass
	
func toggle_projectile_damage(b : bool) -> void:
	pass

func hide_projectile() -> void:
	pass

func projectile_active() -> bool:
	return true

func unhide_projectile() ->void:
	pass

func return_projectile() -> void:
	next_attack_stage()

func _Update(_delta) -> void:
	if character.scale.y == -1:
		process_inverted_gravity(_delta)
	else:
		process_gravity(_delta)
		
	if attack_stage == 0 and has_finished_last_animation():
		play_animation_once("stop")
		activate_touch_damage()
		return_projectile()
		next_attack_stage()
		
	#attack_stage 1 is tween in return_projectile()
		
	elif attack_stage == 2:
		play_animation_once("idle")
		force_movement_toward_direction(horizontal_velocity, character.get_direction())
		#projectile.position.y = (cos(timer * frequency) * jump_velocity) - 9
		if is_colliding_with_wall() or is_near_ledge() or is_over_range():
			turn()
