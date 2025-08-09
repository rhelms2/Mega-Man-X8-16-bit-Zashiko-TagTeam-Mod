extends AttackAbility

const travel_speed := 550.0
const jump_speed := -500.0
onready var smoke_dash: Particles2D = $"../smoke_dash"
onready var highslash: Node2D = $highslash
onready var lowslash: Node2D = $lowslash
onready var high: CollisionShape2D = $"../area2D/high"
onready var high2: CollisionShape2D = $"../area2D/high2"
onready var sword: AudioStreamPlayer2D = $"../sword"
onready var dash: AudioStreamPlayer2D = $dash
onready var slash: AudioStreamPlayer2D = $slash
onready var land: AudioStreamPlayer2D = $land

export var projectile : PackedScene

func _Setup() -> void:
	turn_and_face_player()

func play_sword():
	sword.play_rp(0.03,0.93)

func _Update(_delta) -> void:
	process_gravity(_delta)

	if attack_stage == 0:
		play_animation("low_dash_prepare")
		Tools.timer(0.1,"play_sword",self)
		next_attack_stage()
	
	elif attack_stage == 1 and has_finished_last_animation():
		play_animation("low_dash_prepare_loop")
		next_attack_stage()
	
	elif attack_stage == 2 and timer > 0.3:
		if is_player_above(64) and get_distance_from_player() < 64:
			go_to_attack_stage(5)
		else:
			play_animation("low_dash")
			dash.play_rp()
			smoke_dash.emitting = true
			force_movement(travel_speed)
			reduce_collider()
			next_attack_stage()
	
	elif attack_stage == 3 and has_finished_last_animation():
		play_animation("low_dash_loop")
		lowslash.activate()
		next_attack_stage()

	elif attack_stage == 4:
		if timer > .25 or is_colliding_with_wall() or not is_player_in_front() and get_distance_from_player() > 64:
			play_animation("low_dash_pause")
			reset_collider()
			lowslash.deactivate()
			decay_speed(0.5,0.2)
			next_attack_stage()
			
	elif attack_stage == 5 and has_finished_last_animation():
		play_animation("upward_start")
		smoke_dash.emitting = false
		slash.play_rp(0.03,1.2)
		turn_and_face_player()
		next_attack_stage()
		
	elif attack_stage == 6 and has_finished_last_animation():
		play_animation("upward")
		create_wave()
		highslash.activate()
		set_vertical_speed(jump_speed)
		force_movement(travel_speed/2)
		next_attack_stage()
	
	elif attack_stage == 7 and has_finished_last_animation():
		play_animation("upward_loop")
		decay_speed(0.5,0.6)
		next_attack_stage()

	elif attack_stage == 8 and timer > 0.07:
		play_animation("upward_end")
		highslash.deactivate()
		next_attack_stage()
	
	elif attack_stage == 9 and character.is_on_floor():
		play_animation("land")
		screenshake(0.7)
		land.play_rp()
		next_attack_stage()
	
	elif attack_stage == 10 and timer > 0.15:
		EndAbility()

func _Interrupt() -> void:
	._Interrupt()
	lowslash.deactivate()
	highslash.deactivate()
	smoke_dash.emitting = false
	reset_collider()

func turn_and_face_player():
	.turn_and_face_player()
	highslash.handle_direction()
	lowslash.handle_direction()
	
func reduce_collider():
	high.set_deferred("disabled",true)
	high2.set_deferred("disabled",true)

func reset_collider():
	high.set_deferred("disabled",false)
	high2.set_deferred("disabled",false)
	
func create_wave():
	var shot = instantiate_projectile(projectile)
	shot.global_position.x += 40 * character.get_facing_direction()
	shot.set_horizontal_speed(200 * character.get_facing_direction())
