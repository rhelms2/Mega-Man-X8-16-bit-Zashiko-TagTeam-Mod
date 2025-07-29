extends AttackAbility

export  var projectile: PackedScene
onready var shot_sound: AudioStreamPlayer2D = $shot_sound

func _Update(delta: float) -> void :
	process_gravity(delta)
	if attack_stage == 0:
		turn_and_face_player()
		play_animation("shot")
		shot_sound.play()
		create_projectile(Vector2(get_facing_direction(), 0))
		create_projectile(Vector2(0.5 * get_facing_direction(), - 0.5))
		next_attack_stage()
	elif attack_stage == 1 and has_finished_last_animation():
		play_animation("idle")
		next_attack_stage()
	

func _EndCondition() -> bool:
	return attack_stage == 2 and timer > 1.5

func create_projectile(target_dir: Vector2) -> void :
	var shot = instantiate_projectile(projectile)
	shot.global_position = character.global_position
	shot.global_position.y = character.global_position.y - 4
	shot.set_horizontal_speed(150 * target_dir.x)
	shot.set_vertical_speed(150 * target_dir.y)
