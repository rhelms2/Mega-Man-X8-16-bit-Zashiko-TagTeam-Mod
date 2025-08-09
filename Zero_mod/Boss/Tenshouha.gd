extends AttackAbility

onready var boss_ai = get_parent().get_node("BossAI")
onready var youdantotsu: Node2D = $youdantotsu
onready var youdantotsu_upgraded: Node2D = $youdantotsu_upgraded
onready var youdantotsu_upgraded_hitbox = youdantotsu_upgraded.get_node("area2D/collisionShape2D")
onready var youdantotsu_sfx = $youdantotsu_sfx
onready var ground_check: RayCast2D = $ground_check
onready var laser = preload("res://src/Actors/Bosses/OpticSunflower/CrushBeam.tscn")

var start_speed = 500
var horizontal_speed = start_speed
var damping = 0.95
var laser_casted: bool = false


func _Setup() -> void :
	turn_and_face_player()
	play_animation("idle")
	youdantotsu.handle_direction()
	youdantotsu_upgraded.handle_direction()
	if boss_ai.used_desperation:
		start_speed = 1500
	horizontal_speed = start_speed

func _Update(delta: float) -> void :
	process_gravity(delta)
	
	if attack_stage == 0:
		if is_player_above(16) and is_player_nearby_horizontally(64) and not boss_ai.used_desperation:
			play_animation("tenshouha_start")
			next_attack_stage()
		elif is_player_above(16) and is_player_nearby_horizontally(80) and boss_ai.used_desperation:
			play_animation("tenshouha_start")
			next_attack_stage()
		else:
			play_animation("youdantotsu_start")
			go_to_attack_stage(2)
	
	elif attack_stage == 1 and has_finished_last_animation():
		play_animation("tenshouha")
		if boss_ai.used_desperation:
			screenshake(1.4)
		else:
			screenshake(0.7)
		fire_laser()
		go_to_attack_stage(9)
	
	elif attack_stage == 2 and has_finished_last_animation():
		if boss_ai.used_desperation:
			play_animation("youdantotsu_upgraded")
			screenshake(0.7)
		else:
			play_animation("youdantotsu")
		youdantotsu_sfx.play()
		next_attack_stage()

	elif attack_stage == 3:
		if animatedSprite.frame >= 5:
			youdantotsu_upgraded_hitbox.scale.y = 0.5
		if damage_frames():
			if boss_ai.used_desperation:
				youdantotsu_upgraded.activate()
			else:
				youdantotsu.activate()
		else:
			if boss_ai.used_desperation:
				youdantotsu_upgraded.deactivate()
			else:
				youdantotsu.deactivate()
			
		if movement_speed_frames():
			force_movement(horizontal_speed)
			damp_horizontal_speed(delta)
		else:
			force_movement(0)
			
		if has_finished_last_animation():
			go_to_attack_stage(8)
		
	elif attack_stage == 8 and has_finished_last_animation():
		kill_tweens(tween_list)
		play_animation("saber_recover")
		go_to_attack_stage(10)
	
	elif attack_stage == 9 and has_finished_last_animation():
		kill_tweens(tween_list)
		play_animation("recover")
		next_attack_stage()
			
	elif attack_stage == 10 and has_finished_last_animation():
		EndAbility()

func _Interrupt() -> void :
	._Interrupt()


func fire_laser() -> void :
	var ground_position = Vector2(global_position.x, global_position.y + 256)
	if ground_check.is_colliding():
		ground_position = ground_check.get_collision_point()
	create_laser(ground_position)
	if boss_ai.used_desperation:
		create_laser(ground_position + Vector2( + 32, 0))
		create_laser(ground_position + Vector2( - 32, 0))

func create_laser(ground_position) -> void :
	var instance = laser.instance()
	ground_position.y += 7
	instance.modulate = Color(1, 1, 1, 0.65)
	instance.z_index = character.z_index + 10
	instance.get_node("animatedSprite").material = null
	instance.get_node("animatedSprite2").material = null
	if boss_ai.used_desperation:
		instance.get_node("DamageOnTouch").damage = 16
	get_tree().current_scene.get_node("Objects").call_deferred("add_child", instance, true)
	instance.set_global_position(ground_position)


func damp_horizontal_speed(_delta: float) -> void :
	var reference_delta = 1.0 / 120
	var damping_factor = pow(damping, _delta / reference_delta)
	horizontal_speed *= damping_factor

func movement_speed_frames():
	return animatedSprite.frame >= 1 and animatedSprite.frame < 8

func end_saber_state():
	return animatedSprite.frame >= 11

func damage_frames():
	if animatedSprite.frame >= 1 and animatedSprite.frame < 8:
		return true
	return false
