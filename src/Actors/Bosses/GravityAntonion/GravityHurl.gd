extends AttackAbility
onready var createbox: AudioStreamPlayer2D = $createbox

export var projectile : PackedScene

func _Update(delta) -> void:
	process_gravity(delta)
	if attack_stage == 0:
		play_animation("summon_prepare")
		next_attack_stage()
		createbox.play()
	
	elif attack_stage == 1 and has_finished_last_animation():
		play_animation("summon_start")
		next_attack_stage()
	
	elif attack_stage == 2 and has_finished_last_animation():
		play_animation("summon_loop")
		var p = instantiate(projectile)
		p.global_position.y = character.global_position.y - 144
		p.global_position.x = GameManager.get_player_position().x
		p.floor_position = character.global_position.y - 28
		next_attack_stage()
	
	elif attack_stage == 3 and timer > 0.35:
		play_animation("hurl")
		next_attack_stage()
	
	elif attack_stage == 4 and timer > 0.35:
		EndAbility()
