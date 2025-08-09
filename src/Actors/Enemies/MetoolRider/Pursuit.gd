extends AttackAbility

export var projectile : PackedScene
const distance := Vector2(128,64)
const escape_distance := Vector2(384,64)
onready var shot_sound: AudioStreamPlayer2D = $shot_sound
var shots_fired := 0

func _Setup() -> void:
	shots_fired = 0

func _Update(delta) -> void:
	process_gravity(delta)
	if attack_stage == 0:
		turn_and_face_player()
		play_animation("walk")
		next_attack_stage_on_next_frame()
	
	elif attack_stage == 1:
		force_movement(60)
		if is_player_nearby(distance):
			turn_and_face_player()
			force_movement(0.0)
			play_animation("shot_prepare")
			next_attack_stage()
		elif not is_player_nearby(escape_distance):
			EndAbility()
	
	elif attack_stage == 2 and has_finished_last_animation():
		play_animation_again("shot")
		create_projectile()
		shot_sound.play()
		next_attack_stage()
	
	elif attack_stage == 3 and has_finished_last_animation():
		if is_player_nearby(distance) and shots_fired < 3:
			go_to_attack_stage(2)
		else:
			play_animation("shot_end")
			next_attack_stage()
		
	elif attack_stage == 4 and has_finished_last_animation():
		EndAbility()

func _Interrupt() -> void:
	play_animation("idle")
	force_movement(0)

func create_projectile() -> void:
	shots_fired += 1
	var shot = instantiate_projectile(projectile)
	shot.global_position = character.global_position
	shot.global_position.x += 8 * get_facing_direction()
	shot.global_position.y += 6
	shot.set_horizontal_speed(150 * get_facing_direction())
	shot.set_vertical_speed(0)
