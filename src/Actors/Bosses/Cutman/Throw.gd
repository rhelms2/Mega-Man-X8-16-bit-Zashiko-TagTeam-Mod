extends AttackAbility

export var projectile : PackedScene

func _Setup() -> void:
	turn_and_face_player()
	play_animation("Throw")
	Event.emit_signal("cutman_throw")

func _Update(delta) -> void:
	process_gravity(delta)
	
	if attack_stage == 0 and timer > 0.16:
		create_projectile()
		next_attack_stage()
	
	elif attack_stage == 1 and timer > .4:
		EndAbility()

func create_projectile():
	var p = instantiate(projectile)
	p.set_creator(character)
	p.initialize(character.get_facing_direction())
	p.cutman = character
	pass
