extends AttackAbility
onready var prepare: AudioStreamPlayer2D = $prepare
onready var shot_sound: AudioStreamPlayer2D = $shot_sound

onready var turn: AudioStreamPlayer2D = $turn
export var projectiles : Array
var projectile_number := 0
var second_volley := false

func _Setup(): #override
	projectile_number = 0
	attack_stage = 0
	second_volley = false
	pass

func _Update(_delta) -> void:
	if attack_stage == 0:
		if get_player_direction_relative() != character.get_facing_direction():
			play_animation("turn")
			set_direction(get_player_direction_relative())
			turn.play()
			next_attack_stage()
		else:
			go_to_attack_stage(2)
	
	elif attack_stage == 1 and has_finished_last_animation():
		next_attack_stage()
		
	elif attack_stage == 2:
		play_animation("prepare")
		prepare.play()
		next_attack_stage()
	
	elif attack_stage == 3 and has_finished_last_animation():
		play_animation("fire")
		disparo()
		shot_sound.play()
		next_attack_stage()
		
	elif attack_stage == 4 and has_finished_last_animation():
		second_volley = true
		play_animation("fire2")
		disparo()
		shot_sound.play()
		next_attack_stage()
		
	elif attack_stage == 5 and has_finished_last_animation():
		play_animation("recover")
		next_attack_stage()
			
	elif attack_stage == 6 and has_finished_last_animation():
		EndAbility()

func disparo() -> void:
	for p in projectiles:
		instantiate_multiple(p)
	projectile_number = 0
		
func instantiate_multiple(scene : PackedScene) -> void:
	var projectile = instantiate(scene) 
	projectile.set_creator(self)
	projectile.initialize(character.get_facing_direction())
	if not second_volley:
		projectile.global_position.x = projectile.global_position.x + 44 *  character.get_facing_direction()
		
	projectile.global_position.y = projectile.global_position.y -16
	projectile.global_position.y = projectile.global_position.y + 8 * projectile_number
	
	if projectile_number == 1:
		projectile.global_position.x = projectile.global_position.x + 8 * character.get_facing_direction()
	
	projectile_number += 1
