extends AttackAbility
onready var particles: Particles2D = $"../animatedSprite/particles"
onready var slash_1: Node2D = $slash1
onready var slash_2: Node2D = $slash2
onready var slash_3: Node2D = $slash3
onready var slash_1_sfx: AudioStreamPlayer2D = $slash1_sfx
onready var projectile_sfx: AudioStreamPlayer2D = $projectile_sfx

export var projectile : PackedScene

func _Setup() -> void:
	turn_and_face_player()
	play_animation("slash_1_prepare")

func _Update(delta) -> void:
	if attack_stage == 0 and has_finished_last_animation():
		play_animation("slash_1_prepare_loop")
		go_to_attack_stage(2)
		
	elif attack_stage == 1 and timer > 0.1:
		play_animation("slash_1_start")
		next_attack_stage()
		
	elif attack_stage == 2 and has_finished_last_animation():
		play_animation("slash_1")
		slash_1_sfx.play_rp()
		slash_1.activate()
		screenshake()
		tween_speed(220,0,0.35)
		next_attack_stage()
	
	elif attack_stage == 3 and has_finished_last_animation():
		play_animation("slash_1_loop")
		next_attack_stage()
		
	elif attack_stage == 4 and timer > 0.1:
		turn_and_face_player()
		play_animation("slash_2_prepare")
		tween_speed(220,0,0.35)
		next_attack_stage()
		
	elif attack_stage == 5 and has_finished_last_animation():
		play_animation("slash_2_prepare_loop")
		next_attack_stage()
		
	elif attack_stage == 6 and timer > 0.1:
		play_animation("slash_2")
		slash_1_sfx.play_rp()
		slash_2.activate()
		particles.restart()
		screenshake()
		tween_speed(100,0,0.5)
		next_attack_stage()

	elif attack_stage == 7 and has_finished_last_animation():
		play_animation("slash_2_loop")
		next_attack_stage()

	elif attack_stage == 8 and timer > 0.25:
		if is_player_above() and is_player_in_front():
			play_animation("slash_3_prepare")
			target_dir = get_player_direction()
			tween_speed(20)
			next_attack_stage()
		else:
			play_animation("slash_2_end")
			go_to_attack_stage(12)
	
	elif attack_stage == 9 and has_finished_last_animation():
		play_animation("slash_3")
		instantiate_projectile(projectile)
		projectile_sfx.play_rp()
		slash_3.activate()
		screenshake()
		tween_speed(70)
		next_attack_stage()
	
	elif attack_stage == 10 and has_finished_last_animation():
		play_animation("slash_3_loop")
		next_attack_stage()
	
	elif attack_stage == 11 and timer > 0.3:
		play_animation("slash_3_end")
		next_attack_stage()
	
	elif attack_stage == 12 and has_finished_last_animation():
		EndAbility()
	
func turn_and_face_player():
	.turn_and_face_player()
	slash_1.handle_direction()
	slash_2.handle_direction()
	slash_3.handle_direction()
	

onready var ground_projectile_pos: Position2D = $"../animatedSprite/ground_projectile_pos"

var target_dir : Vector2

func instantiate_projectile(scene : PackedScene) -> Node2D:
	var proj = instantiate(scene) 
	proj.set_creator(self)
	proj.initialize(character.get_facing_direction())
	proj.global_position = ground_projectile_pos.global_position
	proj.set_horizontal_speed(proj.speed * 1.5 * target_dir.x)
	proj.set_vertical_speed(proj.speed * 1.5 * target_dir.y)
	proj.rotate(target_dir.angle())
	proj.scale.x = 1
	return proj

func get_player_direction() -> Vector2:
	return (GameManager.get_player_position() - global_position).normalized()
	
