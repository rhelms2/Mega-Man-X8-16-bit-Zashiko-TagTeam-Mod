extends AttackAbility

export  var cooldown: = 1.0
export  var projectile: PackedScene
var current_aim: = "diagonal"
onready var shot_sound: AudioStreamPlayer2D = $shot_sound
onready var horizontal_spawn_point: Node2D = $horizontal_spawn_point
onready var diagonal_spawn_point: Node2D = $diagonal_spawn_point
onready var initial_rotation: = character.rotation_degrees

func _StartCondition() -> bool:
	if Input.is_action_pressed(actions[0]):
		return true
	return false

func _ready() -> void :
	pass

func _Setup() -> void :
	var new_animation = get_turn_animation_and_set_current_aim()
	play_animation(new_animation)

func _Update(delta: float) -> void :
	if not character.is_on_wall():
		process_gravity(delta)
	if attack_stage == 0 and has_finished_last_animation():
		shoot()
		next_attack_stage()
		
	elif attack_stage == 1 and timer > cooldown:
		EndAbility()
	update_bonus_horizontal_only_conveyor()

func shoot() -> void :
	play_animation("shot_" + current_aim)
	shot_sound.play()
	if current_aim == "horizontal":
		shoot_towards_angle(horizontal_spawn_point.global_position)
		shoot_towards_angle(inverse(horizontal_spawn_point))
		pass
	else:
		shoot_towards_angle(diagonal_spawn_point.global_position)
		shoot_towards_angle(inverse(diagonal_spawn_point))

func shoot_towards_angle(spawn_global_position) -> void :
	var shot = instantiate_projectile(projectile)
	var angle = get_angle(spawn_global_position)
	shot.global_position = spawn_global_position
	shot.set_horizontal_speed(150 * angle.x)
	shot.set_vertical_speed(150 * angle.y)

func inverse(spawn_position) -> Vector2:
	var inverted_pos = spawn_position.position
	inverted_pos.x = - inverted_pos.x
	return to_global(inverted_pos)
	
func get_angle(spawn_global_position) -> Vector2:
	return (spawn_global_position - global_position).normalized()

func get_turn_animation_and_set_current_aim() -> String:
	if current_aim == "horizontal":
		current_aim = "diagonal"
		return "turn_to_diagonal"

	current_aim = "horizontal"
	return "turn_to_horizontal"

func _on_Turret_zero_health() -> void :
	character.rotation_degrees -= initial_rotation
	if "Room" in character.get_parent().name:
		character.rotation_degrees = character.get_parent().rotation_degrees
