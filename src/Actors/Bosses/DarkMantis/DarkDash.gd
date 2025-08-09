extends AttackAbility

export (PackedScene) var projectile 
var target_dir := Vector2.ZERO
onready var hitbox: Node2D = $EnemyMeleeAttack
onready var dash_smoke: Particles2D = $dash_smoke
onready var cut_1: AudioStreamPlayer2D = $cut1
onready var cut_2: AudioStreamPlayer2D = $cut2
onready var dash: AudioStreamPlayer2D = $dash
onready var land: AudioStreamPlayer2D = $land


func _Update(delta):
	if attack_stage == 0 and has_finished_last_animation():
		play_animation_once("dash_start")
		dash.play()
		dash_smoke.emitting = true
		force_movement(get_horizontal_velocity())
		update_hitbox()
		next_attack_stage_on_next_frame()
	
	elif attack_stage == 1:
		if has_finished_animation("dash_start"):
			play_animation_once("dash")
		if is_player_nearby_horizontally(64) or timer > 1 or is_colliding_with_wall():
			next_attack_stage_on_next_frame()
	
	elif attack_stage == 2:
		cut_1.play()
		dash_smoke.emitting = false
		force_movement(get_horizontal_velocity()*0.15)
		set_vertical_speed(-get_jump_velocity()*0.85)
		play_animation_once("slash_1")
		activate_hitbox()
		next_attack_stage_on_next_frame()
	
	elif attack_stage == 3:
		process_gravity(delta)
		if timer > 0.23:
			next_attack_stage_on_next_frame()
		if character.is_on_floor():
			EndAbility()
	elif attack_stage == 4:
		turn_and_face_player()
		set_player_direction()
		play_animation_once("slash_2_start")
		next_attack_stage_on_next_frame()
	
	elif attack_stage == 5:
		process_gravity(delta)
		if has_finished_last_animation():
			cut_2.play()
			play_animation_once("slash_2")
# warning-ignore:return_value_discarded
			instantiate_projectile(projectile)
			force_movement(get_horizontal_velocity()*-0.35)
			set_vertical_speed(-get_jump_velocity()*0.35)
			next_attack_stage_on_next_frame()
	
	elif attack_stage == 6:
		process_gravity(delta)
		if character.is_on_floor():
			land.play()
			play_animation_once("land")
			decay_speed(0.45, 0.35)
			next_attack_stage_on_next_frame()
			
	elif attack_stage == 7 and has_finished_last_animation():
			play_animation_once("idle")
			EndAbility()

func _Interrupt() -> void:
	._Interrupt()
	dash_smoke.emitting = false

func activate_hitbox() -> void:
	hitbox.activate()

func update_hitbox() -> void:
	hitbox.handle_direction()
	
func instantiate_projectile(scene : PackedScene) -> Node2D:
	var proj = instantiate(scene) 
	proj.set_creator(self)
	proj.initialize(character.get_facing_direction())
	proj.set_horizontal_speed(proj.speed * 2 * target_dir.x)
	proj.set_vertical_speed(proj.speed * 2 * target_dir.y)
	proj.rotate(target_dir.angle())
	proj.scale.x = 1
	return proj

func set_player_direction() -> void:
	target_dir = (GameManager.get_player_position() - global_position).normalized()
	
