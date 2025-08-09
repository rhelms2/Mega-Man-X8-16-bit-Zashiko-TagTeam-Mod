extends AttackAbility
class_name GrabAttack

export var translate_duration := 0.032

var grabbed_player := false
var mashes_pressed := 0

func _Setup() -> void:
	attack_stage = 0
	mashes_pressed = 0
	grabbed_player = false
	turn_and_face_player()

func apply_stuck_state() -> void:
	if can_apply_stuck():
		handle_riding_player()
		grabbed_player = true
		reposition_player()
		set_player_state_and_animation()

func can_apply_stuck() -> bool:
	return not GameManager.player.is_invulnerable()

func handle_riding_player() -> void:
	if GameManager.player.is_executing("Ride"):
		GameManager.player.get_parent().grab_eject()

func set_player_state_and_animation() -> void:
	GameManager.player.force_movement()
	GameManager.player.grabbed = true
	GameManager.player.play_animation("damage")
	GameManager.player.animatedSprite.set_frame(0)

func reposition_player() -> void:
	pass #override with any repositioning

func get_safe_player_grab_position() -> Vector2:
	var wall_distance := get_distance_from_wall()
	var safe_x_position := 0.0
	if abs(wall_distance) > 24:
		safe_x_position = character.global_position.x + (24 * character.get_facing_direction())
	else:
		safe_x_position = character.global_position.x - (wall_distance - 16* character.get_facing_direction())
	#print ("Safe X Position = " + str(safe_x_position))
	return Vector2(safe_x_position,character.global_position.y + 10)

func manage_mashing() -> void:
	if Input.is_action_just_pressed("fire") or \
	Input.is_action_just_pressed("alt_fire") or \
	Input.is_action_just_pressed("jump")  or \
	Input.is_action_just_pressed("dash") or \
	Input.is_action_just_pressed("move_left") or \
	Input.is_action_just_pressed("move_right") or \
	Input.is_action_just_pressed("move_up") or \
	Input.is_action_just_pressed("move_down"):
		mashes_pressed += 1

func mashed_enough() -> bool:
	return mashes_pressed > 5 or timer > 3
