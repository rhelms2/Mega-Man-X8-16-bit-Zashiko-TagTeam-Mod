extends AttackAbility

const speed: Vector2 = Vector2(640, - 150)

export  var projectile: PackedScene
export  var saber_hitbox: Resource = preload("res://Zero_mod/Player/Hitboxes/Enkoujin_Hitbox.tscn")

onready var boss_ai: = get_parent().get_node("BossAI")
onready var sfx_dash: AudioStreamPlayer = get_parent().get_node("dash")
onready var sfx_jump: AudioStreamPlayer = get_parent().get_node("jump")
onready var sfx_land: AudioStreamPlayer = get_parent().get_node("land")
onready var enkoujin: Node2D = $enkoujin
onready var sfx_enkoujin: AudioStreamPlayer = $enkoujin_sfx
onready var dive: AudioStreamPlayer2D = $dive

var current_hitbox: Object = null
var hitbox_upleft: Vector2 = Vector2(0, 0)
var hitbox_downright: Vector2 = Vector2(0, 0)
var hitbox_timer: float = 0.0
var hitbox_time: float = 0.05


func _Setup() -> void :
	turn_and_face_player()
	if boss_ai.used_desperation:
		enkoujin.damage = 10

func _Update(_delta: float) -> void :
	
	hitbox_and_position(_delta)
	if attack_stage == 0:
		play_animation("attack_start")
		next_attack_stage()
		
	elif attack_stage == 1 and has_finished_last_animation():
		if get_forward_wall_position() < 200:
			turn()
		next_attack_stage()
		
	elif attack_stage == 2:
		jump_and_next_stage()
		
	elif attack_stage == 3:
		if has_finished_last_animation():
			play_animation_once("dash_loop")
		if is_colliding_with_wall():
			wallslide_and_next_stage()
			
	elif attack_stage == 4 and has_finished_last_animation():
		play_animation("wall_loop")
		next_attack_stage()
		
	elif attack_stage == 5 and timer > 0.01:
		jump_and_next_stage()
		
	elif attack_stage == 6:
		if has_finished_last_animation():
			play_animation_once("dash_loop")
			
		if is_player_nearby_horizontally(24) and not is_player_above(20):
			go_to_attack_stage(10)
			
		elif is_colliding_with_wall():
			wallslide_and_next_stage()
			
	elif attack_stage == 7 and has_finished_last_animation():
		play_animation("wall_loop")
		go_to_attack_stage(5)
		
	elif attack_stage == 10:
		play_animation("enkoujin_prepare")
		force_movement(0)
		set_vertical_speed(0)
		next_attack_stage()
		
	elif attack_stage == 11 and has_finished_last_animation():
		play_animation("enkoujin_loop")
		set_vertical_speed(320)
		sfx_enkoujin.play()
		enkoujin.handle_direction()
		enkoujin.activate()
		next_attack_stage()
		
	elif attack_stage == 12 and character.is_on_floor():
		play_animation("enkoujin_land")
		dive.play()
		if boss_ai.used_desperation:
			screenshake(1.4)
			create_wave()
			Tools.timer(0.2, "create_wave", self)
			Tools.timer(0.4, "create_wave", self)
		next_attack_stage()
		
	elif attack_stage == 13 and has_finished_last_animation():
		play_animation("saber_recover")
		enkoujin.deactivate()
		next_attack_stage()
		
	elif attack_stage == 14 and has_finished_last_animation() or attack_stage == 13 and animatedSprite.animation == "idle":
		EndAbility()

func wallslide_and_next_stage() -> void :
	turn()
	adjust_position_to_wall(0)
	play_animation("wall_land")
	sfx_land.play()
	decay_vert_speed()
	force_movement(0)
	next_attack_stage()

func jump_and_next_stage() -> void :
	play_animation("dash_loop")
	force_movement(speed.x)
	set_vertical_speed(speed.y)
	sfx_jump.play()
	sfx_dash.play()
	next_attack_stage()

func decay_vert_speed(duration: float = 0.15) -> void :
	var tween = get_tree().create_tween()
	tween.tween_method(self, "set_vertical_speed", - 50.0, 0.0, duration)

func create_wave() -> void :
	var shot = instantiate(projectile)
	shot.set_creator(self)
	shot.initialize(1)
	shot.set_horizontal_speed( - 300)
	shot.zero = true
	shot.get_node("animatedSprite").frames = load("res://Zero_mod/Boss/enkoujin_projectile.tres")
	shot.get_node("fire1").texture = load("res://Zero_mod/Boss/fire1.png")
	shot.get_node("fire2").texture = load("res://Zero_mod/Boss/fire2.png")
	shot.get_node("fire3").texture = load("res://Zero_mod/Boss/fire3.png")
	var shot2 = instantiate(projectile)
	shot2.set_creator(self)
	shot2.initialize( - 1)
	shot2.set_horizontal_speed(300)
	shot2.zero = true
	shot2.get_node("animatedSprite").frames = load("res://Zero_mod/Boss/enkoujin_projectile.tres")
	shot2.get_node("fire1").texture = load("res://Zero_mod/Boss/fire1.png")
	shot2.get_node("fire2").texture = load("res://Zero_mod/Boss/fire2.png")
	shot2.get_node("fire3").texture = load("res://Zero_mod/Boss/fire3.png")

func _Interrupt() -> void :
	._Interrupt()

func hitbox_and_position(_delta: float) -> void :
	hitbox_time = 0.05
	if hitbox_timer < hitbox_time:
		hitbox_timer += _delta
	else:
		hitbox_timer = 0
		if animatedSprite.animation == "enkoujin_loop":
			hitbox_upleft = Vector2(1, - 33)
			hitbox_downright = Vector2(33, 20)
			spawn_effect(hitbox_upleft, hitbox_downright)

func spawn_effect(_hitbox_upleft: Vector2, _hitbox_downright: Vector2) -> void :
	current_hitbox = saber_hitbox.instance()
	get_tree().root.add_child(current_hitbox)
	
	var facing_direction = get_facing_direction()
	
	var position_x = global_position.x - 3 * facing_direction
	var position_y = global_position.y + 30
	var hitbox_position = Vector2(position_x, position_y)
	
	if facing_direction == - 1:
		var temp_upleft = Vector2( - _hitbox_downright.x, _hitbox_upleft.y)
		var temp_downright = Vector2( - _hitbox_upleft.x, _hitbox_downright.y)
		current_hitbox.set_hitbox(temp_upleft, temp_downright, hitbox_position)
	else:
		current_hitbox.set_hitbox(_hitbox_upleft, _hitbox_downright, hitbox_position)
	current_hitbox.z_index = character.z_index + 5
	current_hitbox.modulate = Color(1, 1, 1, 0.5)
	current_hitbox.animatedSprite.scale = Vector2(0.75, 0.75)
	current_hitbox.damage = 4
	if current_hitbox.is_in_group("Player Projectile"):
		current_hitbox.remove_from_group("Player Projectile")
		
	var collision = current_hitbox.get_node("collisionShape2D")
	var area2d = current_hitbox.get_node("area2D")
	if collision:
		current_hitbox.get_node("collisionShape2D").queue_free()
	if area2d:
		current_hitbox.get_node("area2D").queue_free()
