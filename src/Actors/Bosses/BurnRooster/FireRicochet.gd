extends AttackAbility

var gravity := true
var voadora_speed := 600.0
var voadora_dir : Vector2
var wallhit_count := 0

export (PackedScene) var land_projectile

onready var raycast: RayCast2D = $rayCast2D
onready var floorcast: RayCast2D = $rayCast2D2
onready var animated_sprite: AnimatedSprite = $"../animatedSprite"
onready var fire_1: Particles2D = $fire1
onready var fire_2: Particles2D = $fire2
onready var fire_3: Particles2D = $fire3
onready var land: Particles2D = $land

onready var charge: AudioStreamPlayer2D = $charge
onready var start: AudioStreamPlayer2D = $start
onready var wallhit: AudioStreamPlayer2D = $wallhit
onready var land_2: AudioStreamPlayer2D = $land2
onready var jump: AudioStreamPlayer2D = $jump
onready var fire_exp: Particles2D = $FireExp
onready var explosion: Particles2D = $Explosion


func _Setup() -> void:
	._Setup()
	gravity = true
	wallhit_count = 0

func activate_fire_particles() -> void:
	fire_1.emitting = true
	fire_2.emitting = true
	fire_3.emitting = true

func deactivate_fire_particles() -> void:
	fire_1.emitting = false
	fire_2.emitting = false
	fire_3.emitting = false

func _Update(delta) -> void:
	if gravity:
		process_gravity(delta)
	if abs(get_actual_speed()) < 20:
		land.emitting = false
	
	if attack_stage == 0 and has_finished_last_animation():
		turn_and_face_player()
		set_vertical_speed(-jump_velocity)
		force_movement(-horizontal_velocity)
		play_animation_once("jump")
		jump.play()
		next_attack_stage()
	
	elif attack_stage == 1 and timer > 0.5:
		turn_and_face_player()
		set_vertical_speed(0)
		force_movement(0)
		gravity = false
		play_animation_once("voadora_prepare")
		charge.play()
		fire_1.emitting = true
		get_voadora_direction()
		next_attack_stage_on_next_frame()
	
	elif attack_stage == 2 and timer > 0.35:
		activate_fire_particles()
		play_animation_once("voadora_loop_start")
		start.play()
		go_towards_direction()
		next_attack_stage()
	
	elif attack_stage == 3:
		if is_near_ground(): #end
			go_to_attack_stage(6)
		
			
		elif is_colliding_with_wall():
				next_attack_stage()
	
		elif is_near_ceiling():
			deflect_voadora_dir()
	
			go_to_attack_stage(5)
		if has_finished_last_animation():
			play_animation_once("voadora_loop")
	
	elif attack_stage == 4: #wall hit
		turn()
		wallhit.play()
		explosion_visual() 
		fire_exp.restart()
		explosion.restart()
		fire_exp.emitting = true
		explosion.emitting = true
		if wallhit_count < 2:
			force_movement(-abs(voadora_speed * voadora_dir.x))
			voadora_dir.x *= -1
			wallhit_count += 1
		else:
			direct_towards_floor()
		go_to_attack_stage_on_next_frame(3)
	
	elif attack_stage == 5 and timer > 0.05: #ceiling hit
		go_to_attack_stage_on_next_frame(3)
		
	elif attack_stage == 6: #floor hit
		explosion_visual() 
		animated_sprite.rotation = 0
		land.emitting = true 
		play_animation_once("land")
		land_2.play()
		screenshake()
		deactivate_fire_particles()
		fire_projectiles()
		decay_speed(0.5,0.35)
		next_attack_stage()
	
	elif attack_stage == 7 and has_finished_last_animation():
		EndAbility()

func explosion_visual() -> void:
	fire_exp.restart()
	explosion.restart()
	fire_exp.emitting = true
	explosion.emitting = true

func _Interrupt() -> void:
	animated_sprite.rotation = 0
	deactivate_fire_particles()
	land.emitting = false
	play_animation_once("idle")

func get_voadora_direction() -> void:
	var target_dir = Tools.get_player_angle(global_position)
	var correct_dir = Vector2(-target_dir.x, target_dir.y)
	voadora_dir = correct_dir

func rotate_voadora_direction(degs) -> void:
	voadora_dir = voadora_dir.rotated(deg2rad(degs))

func go_towards_direction(rotate := true) -> void:
	force_movement(abs(voadora_speed * voadora_dir.x))
	set_vertical_speed(voadora_speed * voadora_dir.y)
	if rotate:
		rotate_voadora()

func turn() -> void:
	.turn()
	animated_sprite.rotation *= -1

func rotate_voadora() -> void:
	if character.get_facing_direction() < 0:
		animated_sprite.rotation = -voadora_dir.angle()
	else:
		animated_sprite.rotation = -voadora_dir.angle() - deg2rad(180)

func direct_towards_floor() -> void:
	if character.get_facing_direction() == 1:
		voadora_dir = Vector2(0.75,0.25)
	else:
		voadora_dir = Vector2(-0.75,0.25)
	force_movement(- abs(voadora_speed * voadora_dir.x))
	set_vertical_speed(voadora_speed * voadora_dir.y)
	voadora_dir.x *= -1
	voadora_dir.y *= -1
	rotate_voadora()

func deflect_voadora_dir() -> void:
	voadora_dir = voadora_dir.reflect(Vector2.RIGHT)
	explosion_visual() 
	go_towards_direction() 

func is_near_ceiling() -> bool:#
	return raycast.is_colliding()
func is_near_ground() -> bool:#
	return floorcast.is_colliding()

func fire_projectiles() -> void:
	var shot = instantiate_projectile(land_projectile)
	var shot2 = instantiate_projectile(land_projectile)
	shot.global_position.y += 32
	shot2.global_position.y += 32
	shot.set_horizontal_speed(700)
	shot2.set_horizontal_speed(-700)
