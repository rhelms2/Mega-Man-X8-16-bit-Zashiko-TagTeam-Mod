extends AttackAbility
export var bouncer : PackedScene
var turning := false

func _Setup() -> void:
	turning = false
	if not is_facing_player():
		play_animation("turn")
		turning = true

func activate() -> void:
	.activate()
	animatedSprite.connect("animation_finished",self,"on_finished_animation")

func _Update(_delta) -> void:
	process_gravity(_delta)
	if attack_stage == 0:
		if turning: 
			if has_finished_last_animation():
				turn()
				play_animation("shot_prepare")
				next_attack_stage()
		else:
			play_animation("shot_prepare")
			next_attack_stage()
	
	elif attack_stage == 1 and has_finished_last_animation():
		play_animation("shot_loop")
		next_attack_stage()
	
	elif attack_stage == 2 and timer > 0.75:
		play_animation("shot")
		#throw.play_rp()
		fire_bouncer(120.0 * get_facing_direction(), 100.0)
		fire_bouncer(165.0 * get_facing_direction(), 0)
		fire_bouncer(120.0 * get_facing_direction(), -100.0)
		next_attack_stage()
		
	elif attack_stage == 3 and has_finished_last_animation():
		EndAbility()

func fire_bouncer(h_speed : float, v_speed : float) -> void:
	var b = instantiate_projectile(bouncer)
	b.set_horizontal_speed(h_speed)
	b.set_vertical_speed(v_speed)
	b.global_position.x += 38 * get_facing_direction()
	b.global_position.y -= 11

func _on_Defence_unable_to_defend() -> void:
	if not active:
		activate()
