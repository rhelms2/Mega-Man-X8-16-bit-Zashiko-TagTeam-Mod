extends AttackAbility
export var spike : PackedScene

func _Update(_delta):
	if attack_stage == 0 and timer > 0.5:
		play_animation("ground")
		create_spike()
		next_attack_stage()
	
	elif attack_stage == 1 and timer > 1.0:
		play_animation("ground_end")
		next_attack_stage()
		
	elif attack_stage == 2 and has_finished_last_animation():
		EndAbility()

func create_spike():
	var new_spike = spike.instance()
	new_spike.direction = get_facing_direction()
	character.get_parent().call_deferred("add_child",new_spike)
	new_spike.global_position = character.global_position + Vector2(16*get_facing_direction(),23)

