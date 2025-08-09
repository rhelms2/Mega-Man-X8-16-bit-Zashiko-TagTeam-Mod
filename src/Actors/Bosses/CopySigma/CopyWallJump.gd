extends AttackAbility

const speed := Vector2(800,-150)
onready var sword: AudioStreamPlayer2D = $"../sword"
onready var land: AudioStreamPlayer2D = $land
onready var jump: AudioStreamPlayer2D = $jump
onready var dive: AudioStreamPlayer2D = $dive
export var projectile : PackedScene
onready var low: CollisionShape2D = $"../area2D/low"
onready var high_2: CollisionShape2D = $"../area2D/high2"

func _Setup() -> void:
	turn_and_face_player()

func _Update(_delta) -> void:
	if attack_stage == 0:
		play_animation("jump_start")
		sword.play_rp(0.03,1.1)
		next_attack_stage()
	
	elif attack_stage == 1 and has_finished_last_animation():
		play_animation("jump_start_loop")
		next_attack_stage()
	
	elif attack_stage == 2 and timer > 0.4:
		jump_and_next_stage()

	elif attack_stage == 3: #FIRST JUMP
		if has_finished_last_animation():
			play_animation_once("jump_loop")
		if is_colliding_with_wall():
			wallslide_and_next_stage()
	
	elif attack_stage == 4 and has_finished_last_animation():
		play_animation("wall_loop")
		next_attack_stage()
	
	elif attack_stage == 5 and timer > 0.01:
		jump_and_next_stage()
	
	elif attack_stage == 6: #SECOND JUMP
		if has_finished_last_animation():
			play_animation_once("jump_loop")
	
		if is_player_nearby_horizontally(24) and not is_player_above(20): #go to dive
			go_to_attack_stage(10)
	
		elif is_colliding_with_wall():
			wallslide_and_next_stage()
	
	elif attack_stage == 7 and has_finished_last_animation():
		play_animation("wall_loop")
		go_to_attack_stage(5)
	
	elif attack_stage == 10: #dive prepare
		play_animation("downward_prepare")
		force_movement(0)
		set_vertical_speed(0)
		next_attack_stage()
	
	elif attack_stage == 11 and has_finished_last_animation():
		play_animation("downward_loop")
		set_vertical_speed(1000)
		dive.play()
		next_attack_stage()
		
	elif attack_stage == 12 and character.is_on_floor():
		play_animation("downward_land")
		screenshake(1.4)
		create_wave()
		next_attack_stage()
		
	elif attack_stage == 13 and has_finished_last_animation():
		EndAbility()

func wallslide_and_next_stage() -> void:
	turn()
	adjust_position_to_wall()
	play_animation("wall_land")
	land.play_rp()
	decay_vert_speed()
	force_movement(0)
	next_attack_stage()

func jump_and_next_stage() -> void:
	play_animation("jump")
	force_movement(speed.x)
	set_vertical_speed(speed.y)
	jump.play_rp()
	reduce_collider()
	next_attack_stage()

func decay_vert_speed(duration : float = 0.15) -> void:
	var tween = get_tree().create_tween()
	tween.tween_method(self,"set_vertical_speed",-50.0,0.0,duration)

func create_wave():
	var shot = instantiate(projectile) 
	shot.set_creator(self)
	shot.initialize(1)
	shot.set_horizontal_speed(-200)
	
	var shot2 = instantiate(projectile) 
	shot2.set_creator(self)
	shot2.initialize(-1)
	shot2.set_horizontal_speed(200)

func _Interrupt():
	._Interrupt()
	reset_collider()

func reduce_collider():
	low.set_deferred("disabled",true)
	high_2.set_deferred("disabled",true)

func reset_collider():
	low.set_deferred("disabled",false)
	high_2.set_deferred("disabled",false)

