extends AttackAbility

var gravity_scale := 800
export var lance : PackedScene
onready var lance_pos: Position2D = $"../animatedSprite/lance_projectile_pos"
onready var lance_raycast: RayCast2D = $"../animatedSprite/lance_raycast"
onready var laser: AnimatedSprite = $laser
onready var jump: AudioStreamPlayer2D = $jump
onready var projectile_sfx: AudioStreamPlayer2D = $projectile_sfx
onready var charge: AudioStreamPlayer2D = $charge
onready var land: AudioStreamPlayer2D = $land

var target_dir : Vector2
var targetting := false
var repeat_attack:= true

func _Setup() -> void:
	turn_and_face_player()
	play_animation("spear_jump_prepare")
	gravity_scale = 600
	laser.visible = false
	laser.animation = "ready"
	targetting = true
	repeat_attack = true

func target_laser() -> void:
	if targetting:
		laser.look_at(GameManager.get_player_position())
		lance_raycast.look_at(GameManager.get_player_position())
	else:
		laser.look_at(target_dir)
		lance_raycast.look_at(target_dir)

#func make_laser_visible():
#	if executing:
#		laser.set_deferred("visible", true)
	

func _Update(delta) -> void:
	process_gravity(delta,gravity_scale)
	target_laser()
	
	if attack_stage == 0 and has_finished_last_animation():
		jump.play_rp()
		charge.play()
		tween_speed(-40,0,1)
		laser.set_deferred("visible", true)
		play_animation("spear_prepare")
		set_vertical_speed(-300)
		screenshake()
		next_attack_stage()
		
	elif attack_stage == 1 and timer > .15:
		turn_and_face_player()
		target_dir = GameManager.get_player_position()
		targetting = false
		next_attack_stage()
	
	elif attack_stage == 2 and timer > .35:
		play_animation("spear_throw")
		projectile_sfx.play()
		next_attack_stage()
		
	elif attack_stage == 3 and has_finished_last_animation():
		charge.stop()
		play_animation("spear_throw_end")
		laser.animation = "fire"
		call_deferred("instantiate_spear")
		screenshake(0.5)
		tween_speed(-100,0,1)
		set_vertical_speed(-100)
		if repeat_attack:
			repeat_attack = false
			gravity_scale = 300
			next_attack_stage()
		else:
			gravity_scale = 600
			go_to_attack_stage(5)
		
	elif attack_stage == 4 and has_finished_last_animation():
		charge.play()
		tween_speed(-40,0,1)
		laser.set_deferred("visible", true)
		play_animation("spear_prepare")
		set_vertical_speed(-110)
		laser.visible = false
		laser.animation = "ready"
		targetting = true
		go_to_attack_stage(1)
		
	elif attack_stage == 5 and character.is_on_floor():
		play_animation("land")
		land.play_rp()
		laser.visible = false
		screenshake()
		next_attack_stage()
	
	elif attack_stage == 6 and has_finished_last_animation():
		EndAbility()

func _Interrupt():
	._Interrupt()
	laser.set_deferred("visible", false)
	targetting = false

func instantiate_spear():
	if not lance_raycast.is_colliding():
		return
	var collision_point = lance_raycast.get_collision_point()
	var instance := lance.instance()
	instance.set_lance_origin(character.global_position)
	get_tree().current_scene.add_child(instance)
	instance.global_position = collision_point
	instance.hide_far_trails()
	instance.look_at(global_position)
	instance.rotation_degrees += 90
	
