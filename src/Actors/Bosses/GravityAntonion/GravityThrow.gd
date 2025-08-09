extends AttackAbility
onready var throw: AudioStreamPlayer2D = $throw

export var projectile : PackedScene

func _Update(delta) -> void:
	process_gravity(delta)
	if attack_stage == 0:
		play_animation("throw_prepare")
		next_attack_stage()
	
	elif attack_stage == 1 and has_finished_last_animation():
		play_animation("throw")
		throw.play()
		var p = instantiate(projectile)
		p.set_creator(character)
		p.initialize(character.get_facing_direction())
		p.set_vertical_speed(-100)
		next_attack_stage()
	
	elif attack_stage == 2 and has_finished_last_animation():
		EndAbility()
