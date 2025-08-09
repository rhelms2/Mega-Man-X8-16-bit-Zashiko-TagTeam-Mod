extends AttackAbility

export var projectile : PackedScene
onready var point: AudioStreamPlayer2D = $point
onready var space: Node = $"../Space"

func _Update(delta) -> void:
	process_gravity(delta)
	if attack_stage == 0:
		turn_towards_point(space.center)
		play_animation("gravity_prepare")
		next_attack_stage()
	
	elif attack_stage == 1 and has_finished_last_animation():
		play_animation("gravity")
		point.play()
		var p = instantiate(projectile)
		p.global_position = space.center
		p.global_position.y += 48
		next_attack_stage()
	
	elif attack_stage == 2 and timer > 0.5:
		play_animation("gravity_end")
		next_attack_stage()
		EndAbility()
		
	elif attack_stage == 3 and has_finished_last_animation():
		EndAbility()

