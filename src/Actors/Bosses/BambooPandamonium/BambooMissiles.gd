extends AttackAbility

export var missile : PackedScene
onready var shot: AudioStreamPlayer2D = $shot

func _Update(_delta) -> void:
	process_gravity(_delta)
	if attack_stage == 0 and has_finished_last_animation():
		fire_missile(get_max_missile_distance())
		next_attack_stage()
		
	elif attack_stage == 1 and has_finished_last_animation():
		fire_missile(150.0)
		next_attack_stage()
		
	elif attack_stage == 2 and timer > 0.5:
		play_animation("missile_end")
		next_attack_stage()
		
	elif attack_stage == 3 and has_finished_last_animation():
		EndAbility()

func get_max_missile_distance() -> float:
	return clamp(get_distance_from_player() * 1.45,400,1000)

func fire_missile(speed:float) -> void:
	var s = speed * character.get_facing_direction()
	play_animation("missile_shot")
	shot.play_rp(0.03,0.85)
	var p = instantiate_projectile(missile)
	p.global_position += Vector2(55 * character.get_facing_direction(),0)
	Tools.tween_method(p,"set_vertical_speed",0.0,-100.0,1.0)
	Tools.tween_method(p,"set_horizontal_speed",s,0.0,1.0)

