extends AttackAbility

export var projectile : PackedScene
const time_between_actions := 0.15
const shot_speed := 300.0

func _Update(delta : float) -> void:
	process_gravity(delta)
	if attack_stage == 0:
		juggle()
	elif attack_stage == 1:
		wait_a_bit()
	elif attack_stage == 2:
		juggle(1.45)
	elif attack_stage == 3:
		wait_a_bit()
			
	elif attack_stage == 4:
		if timer > time_between_actions:
			go_to_attack_stage(0)

func juggle(speed_factor := 1.0) -> void:
	if timer > time_between_actions* 2:
			play_animation_once("open")
			if timer > time_between_actions + 0.35:
				create_projectile(shot_speed * speed_factor) #1.45
				next_attack_stage()

func wait_a_bit() -> void:
	if timer > time_between_actions:
		play_animation("close")
		next_attack_stage()

func create_projectile(speed : float) -> void:
	var shot = instantiate_projectile(projectile)
	shot.global_position = character.global_position + position
	shot.set_horizontal_speed(0)
	shot.set_vertical_speed(-speed)
	shot.life_duration = speed/shot_speed / 1.5

