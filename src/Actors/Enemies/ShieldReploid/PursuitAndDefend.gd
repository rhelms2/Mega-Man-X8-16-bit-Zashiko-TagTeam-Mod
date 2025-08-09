extends AttackAbility

export var nearby_distance : Vector2
var max_distance : Vector2
var player_direction := 0

var turning := false

func _ready() -> void:
	max_distance = $"../AI/vision/collisionShape2D".shape.extents
	max_distance += Vector2(10,10)

func _Setup() -> void:
	attack_stage = 0
	turning = false

func _Update(_delta) -> void:
	process_gravity(_delta)

	if not player_in_front() and not turning:
		go_to_attack_stage(2)
		turning = true

	if attack_stage == 0:
		if has_finished_animation("ready_start"):
			play_animation_once("ready_loop")
		if timer > 0.5 and not is_player_nearby(nearby_distance):
			play_animation_once("catch")
			next_attack_stage_on_next_frame()
	
	
	elif attack_stage == 1 and has_finished_last_animation():
		play_animation_once("walk_loop")
		process_gravity(_delta)
		force_movement(horizontal_velocity)

		if is_player_nearby(nearby_distance):
			go_to_attack_stage(4)
		
		elif should_stop_pursuing():
			force_movement(0)
			EndAbility()
	
	
	if attack_stage == 2: # turn
		force_movement(0)
		process_gravity(_delta)
		play_animation_once("turn")
		if has_finished_last_animation():
			turn()
			play_animation_once("ready_start")
			next_attack_stage()

	elif attack_stage == 3 and timer > 1: #after turning
		turning = false
		go_to_attack_stage(0)
			
	elif attack_stage == 4: #nearby player
		force_movement(0)
		play_animation_once("ready_start")
		if not is_player_nearby(nearby_distance):
			go_to_attack_stage(0)

func should_stop_pursuing() -> bool:
	if not is_player_nearby_vertically(max_distance.y):
		return true
	elif not is_player_nearby_horizontally(max_distance.x):
		return true
	return false

func player_in_front() -> bool:
	return get_player_direction_relative() == character.get_facing_direction()

	
