extends AttackAbility
class_name MetoolHide

onready var shield: Node2D = $"../EnemyShield"

func _Setup() -> void:
	._Setup()
	force_movement(0)
	shield.activate()

func _Update(delta) -> void:
	process_gravity(delta)
	if attack_stage == 0 and timer > 3 and is_player_looking_away():
		turn_and_face_player()
		play_animation_once("open")
		shield.deactivate()
		next_attack_stage_on_next_frame()
		
	elif attack_stage == 1 and has_finished_last_animation():
		if is_player_nearby_horizontally(64) and is_player_nearby_vertically(16):
			turn_and_face_player()
			play_animation_once("walk")
			force_movement(horizontal_velocity)
			next_attack_stage_on_next_frame()
		else:
			EndAbility()
			
	elif attack_stage == 2:
		if not is_player_nearby_horizontally(80):
			EndAbility()
		elif not is_player_looking_away():
			force_movement(0)
			Tools.timer(0.1, "activate", shield)
			play_animation_once("defense")
			go_to_attack_stage(0)

func _Interrupt() -> void:
	shield.deactivate()

func is_player_looking_away() -> bool:
	return get_player_direction_relative() == GameManager.get_player_facing_direction()
