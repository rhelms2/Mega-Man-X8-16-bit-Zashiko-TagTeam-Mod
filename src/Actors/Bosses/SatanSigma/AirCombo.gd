extends AttackAbility

export var projectile : PackedScene
var gravity_scaling := 800.0
onready var jump_projectile_pos: Position2D = $"../animatedSprite/jump_projectile_pos"
onready var projectile_sfx: AudioStreamPlayer2D = $projectile_sfx
onready var dive: Node2D = $dive
onready var land: AudioStreamPlayer2D = $land
onready var jump: AudioStreamPlayer2D = $jump
onready var land_particles: Particles2D = $"../animatedSprite/land_particles"

func _Setup() -> void:
	turn_and_face_player()
	play_animation("jump_prepare")
	gravity_scaling = 800.0

func _Update(delta) -> void:
	process_gravity(delta, gravity_scaling)
	
	if attack_stage == 0 and has_finished_last_animation():
		play_animation("jump")
		jump.play_rp()
		screenshake()
		gravity_scaling = 700.0
		set_vertical_speed(-400)
		force_movement(-40)
		next_attack_stage()

	elif attack_stage == 1 and timer > 0.5:
		turn_and_face_player()
		play_animation("jumpslash_prepare")
		gravity_scaling = 800.0
		next_attack_stage()

	elif attack_stage == 2 and has_finished_last_animation():
		play_animation("jumpslash")
		set_player_direction()
		instantiate_projectile(projectile)
		set_vertical_speed(-200)
		force_movement(-20)
		go_to_attack_stage(4)
		
	#elif attack_stage == 3 and timer > 0.1:
	#	play_animation("jumplash_tojump")
	#	set_vertical_speed(-100)
	#	next_attack_stage()
	
	elif attack_stage == 4 and timer > 0.25:
		turn_and_face_player()
		play_animation("jumpslash_prepare")
		next_attack_stage()
		
	elif attack_stage == 5 and timer > 0.25:
		play_animation("jumpslash")
		set_player_direction()
		instantiate_projectile(projectile)
		set_vertical_speed(-250)
		force_movement(abs(get_distance_from_player())/2)
		#gravity_scaling = 600
		next_attack_stage()
		
	elif attack_stage == 6 and timer > 0.5:
		turn_and_face_player()
		play_animation("dive_prepare")
		set_vertical_speed(-100)
		tween_speed(abs(get_distance_from_player())*3.5,0,0.5)
		gravity_scaling = 400
		next_attack_stage()

	elif attack_stage == 7 and timer > 0.5:
		play_animation("dive")
		dive.activate()
		set_vertical_speed(600)
		force_movement(0)
		next_attack_stage()

	elif attack_stage == 8:
		if character.is_on_floor() or timer > 5:
			play_animation("dive_land")
			land.play_rp()
			dive.deactivate()
			screenshake()
			land_particles.restart()
			next_attack_stage()

	elif attack_stage == 9 and has_finished_last_animation():
		play_animation("dive_land_loop")
		next_attack_stage()
		
	elif attack_stage == 10 and has_finished_last_animation():
		play_animation("dive_end")
		next_attack_stage()

	elif attack_stage == 11 and has_finished_last_animation():
		EndAbility()

func _Interrupt():
	._Interrupt()
	dive.deactivate()

func process_gravity(_delta:float, gravity := default_gravity) -> void:
	character.add_vertical_speed(gravity * _delta)

var target_dir : Vector2

func instantiate_projectile(scene : PackedScene) -> Node2D:
	var proj = instantiate(scene) 
	proj.set_creator(self)
	proj.initialize(character.get_facing_direction())
	proj.global_position = jump_projectile_pos.global_position
	proj.set_horizontal_speed(proj.speed * 1.25 * target_dir.x)
	proj.set_vertical_speed(proj.speed * 1.25 * target_dir.y)
	proj.rotate(target_dir.angle())
	proj.scale.x = 1
	projectile_sfx.play_rp(0.07,0.8)
	return proj

func set_player_direction() -> void:
	target_dir = (GameManager.get_player_position() - global_position).normalized()
	
func turn_and_face_player():
	.turn_and_face_player()
	dive.handle_direction()
