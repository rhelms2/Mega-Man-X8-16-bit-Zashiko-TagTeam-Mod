extends Axl

var current_weapon
var less_buggy_pressed_dir: int = 0

func _ready():
	is_current_player = true


func _process(delta: float) -> void :
	if Input.is_action_pressed("fire_emulated") or Input.is_action_pressed("alt_fire"):
		is_shooting = true
		Event.emit_signal("is_shooting")
	else:
		is_shooting = false
		Event.emit_signal("is_not_shooting")
		var _shot_node = get_node("Shot")
		if _shot_node != null:
			if _shot_node.current_weapon != null:
				if _shot_node.current_weapon.name == "IceGattling":
					_shot_node.current_weapon._gattling_sprites = 1
					if animatedSprite.frames != _sprites_icegattling_1:
						animatedSprite.frames = _sprites_icegattling_1
	if ride_eject_delay >= 0:
		ride_eject_delay -= delta
	process_flash(delta)

func has_just_pressed_up() -> bool:
	return get_action_just_pressed("up_emulated")

func has_just_pressed_down() -> bool:
	return get_action_just_pressed("down_emulated")

func has_just_pressed_left() -> bool:
	return get_action_just_pressed("left_emulated")

func has_just_pressed_right() -> bool:
	return get_action_just_pressed("right_emulated")

func check_for_dash() -> void :
	if get_action_just_pressed("dash_emulated"):
		Event.emit_signal("input_dash")

func get_action_pressed(action) -> bool:
	if listening_to_inputs:
		return Input.is_action_pressed(action)
	return false

func get_just_pressed_axis() -> int:
	return less_buggy_pressed_dir

func get_pressed_axis() -> int:
	return less_buggy_pressed_dir

func _input(event: InputEvent) -> void :
	if event.is_action_pressed("down_emulated"):
		less_buggy_pressed_dir = 1
	elif event.is_action_released("down_emulated"):
		less_buggy_pressed_dir = 0
	if event.is_action_pressed("up_emulated"):
		less_buggy_pressed_dir = - 1
	elif event.is_action_released("up_emulated"):
		less_buggy_pressed_dir = 0
	if event.is_action_pressed("right_emulated"):
		less_buggy_pressed_dir = 1
	elif event.is_action_released("right_emulated"):
		less_buggy_pressed_dir = 0
	if event.is_action_pressed("left_emulated"):
		less_buggy_pressed_dir = - 1
	elif event.is_action_released("left_emulated"):
		less_buggy_pressed_dir = 0
