extends AttackAbility

export var bouncer : PackedScene
onready var throw: AudioStreamPlayer2D = $throw

func _Setup() -> void:
	turn_and_face_player()
	play_animation("shot_prepare")

func _Update(delta) -> void:
	process_gravity(delta)
	if attack_stage == 0 and has_finished_last_animation():
		play_animation("shot")
		throw.play_rp()
		fire_bouncer(200.0 * get_facing_direction(), 0.0)
		fire_bouncer(150.0 * get_facing_direction(), -50.0)
		fire_bouncer(100.0 * get_facing_direction(), -100.0)
		next_attack_stage()
		
	elif attack_stage == 1 and has_finished_last_animation():
		EndAbility()

func fire_bouncer(h_speed : float, v_speed : float) -> void:
	var b = instantiate_projectile(bouncer)
	b.set_horizontal_speed(h_speed)
	b.set_vertical_speed(v_speed)
	if not is_touching_wall() == get_facing_direction():
		b.global_position.x += 32 * get_facing_direction()

func is_touching_wall() -> int:
	if Tools.raycast(self,Vector2(24,0)):
		return 1
	elif Tools.raycast(self,Vector2(-24,0)):
		return -1
	return 0
