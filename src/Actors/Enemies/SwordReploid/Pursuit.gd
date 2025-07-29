extends AttackAbility


export  var nearby_distance: Vector2
var max_distance: Vector2
var player_direction: = 0
var turning: = false
onready var slash: Node2D = $SlashHitbox

func _ready() -> void :
	max_distance = $"../AI/vision/collisionShape2D".shape.extents
	max_distance += Vector2(10, 10)

func _StartCondition() -> bool:
	return character.is_on_floor()

func _Setup() -> void :
	attack_stage = 0
	turning = false

func go_to_slash_state() -> void :
	decay_speed()
	slash.handle_direction()
	go_to_attack_stage(4)

func _Update(_delta: float) -> void :
	process_gravity(_delta)
	handle_turning()

	if attack_stage == 0 and has_finished_last_animation():
		play_animation_once("ready_loop")
		if is_player_nearby(nearby_distance):
			go_to_slash_state()
		if timer > 0.5 and not is_player_nearby(nearby_distance):
			next_attack_stage_on_next_frame()
	
	
	elif attack_stage == 1 and has_finished_last_animation():
		play_animation_once("walk_loop")
		force_movement(horizontal_velocity)
		if is_player_nearby(nearby_distance):
			go_to_slash_state()
		elif should_stop_pursuing():
			force_movement(0)
			play_animation_once("ready_loop")
			go_to_attack_stage(5)
	
	elif attack_stage == 6 and timer > 1:
		if is_player_nearby(nearby_distance):
			go_to_slash_state()
		else:
			EndAbility()
	
	if attack_stage == 2:
		force_movement(0)
		process_gravity(_delta)
		play_animation_once("turn")
		if has_finished_last_animation():
			turn_and_face_player()
			play_animation_once("ready_loop")
			next_attack_stage()

	elif attack_stage == 3 and timer > 0.25:
		turning = false
		go_to_attack_stage(0)
			
	elif attack_stage == 4:
		play_animation_once("slash_prepare")
		if has_finished_last_animation():
			slash.activate()
			play_animation_once("slash_recover")
			next_attack_stage_on_next_frame()
	
	elif attack_stage == 5 and has_finished_last_animation():
		if not is_player_nearby(nearby_distance):
			go_to_attack_stage(0)
		else:
			EndAbility()

func handle_turning() -> void :
	if not player_in_front() and not turning and not attack_stage == 4 and not attack_stage == 5:
		go_to_attack_stage(2)
		turning = true


	
			

func should_stop_pursuing() -> bool:
	if not is_player_nearby_vertically(max_distance.y):
		return true
	elif not is_player_nearby_horizontally(max_distance.x):
		return true
	return false

func player_in_front() -> bool:
	return get_player_direction_relative() == character.get_facing_direction()

func turn_and_face_player() -> void :
	.turn_and_face_player()
	slash.handle_direction()
	
