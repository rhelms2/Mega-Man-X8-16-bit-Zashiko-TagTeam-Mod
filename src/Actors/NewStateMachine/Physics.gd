extends Reference
class_name Physics

const default_gravity: float = 900.0

var character: Actor


func _init(_character) -> void :
	character = _character

func process_gravity(_delta: float, gravity: float = default_gravity) -> void :
	character.add_vertical_speed(gravity * _delta)
	if character.get_vertical_speed() > character.maximum_fall_velocity:
		character.set_vertical_speed(character.maximum_fall_velocity)

func process_inverted_gravity(_delta: float, gravity: = - default_gravity) -> void :
	character.add_vertical_speed(gravity * _delta)

func set_bonus_horizontal_speed_towards_facing_direction(speed: float) -> void :
	character.set_bonus_horizontal_speed(speed * character.get_facing_direction())

func set_bonus_horizontal_speed(speed: float) -> void :
	character.set_bonus_horizontal_speed(speed)

func update_bonus_horizontal_only_conveyor(extra: = 0.0):
	if character.is_on_floor():
		var conveyor_belt = character.get_conveyor_belt_speed()
		var speed = conveyor_belt + extra
		character.set_bonus_horizontal_speed(speed)

func update_bonus_horizontal_speed(extra: = 0.0):
	var ground = character.get_floor_velocity().x
	var conveyor_belt = character.get_conveyor_belt_speed()
	
	var speed = ground + conveyor_belt + extra
	character.set_bonus_horizontal_speed(speed)

func decay_bonus_horizontal_speed(rate: = 0.975):
	var bonus_speed: = character.get_bonus_horizontal_speed()
	bonus_speed = bonus_speed * rate
	character.set_bonus_horizontal_speed(bonus_speed)

func zero_bonus_horizontal_speed():
	character.set_bonus_horizontal_speed(0)

func get_facing_direction() -> int:
	return character.get_facing_direction()

func set_vertical_speed(_jump_velocity: float, snap: = true) -> void :
	character.set_vertical_speed(_jump_velocity, snap)

func get_vertical_speed() -> float:
	return character.get_vertical_speed()

func set_horizontal_speed(_horizontal_velocity: float) -> void :
	if is_instance_valid(character):
		character.set_horizontal_speed(_horizontal_velocity)

func set_horizontal_speed_towards_facing_direction(_horizontal_velocity: float) -> void :
	character.set_horizontal_speed(_horizontal_velocity * character.get_facing_direction())

func increase_horizontal_speed(_horizontal_velocity: float) -> void :
	character.add_horizontal_speed(_horizontal_velocity)

func set_horizontal_speed_toward_direction(_horizontal_velocity: float, direction: int) -> void :
	character.set_horizontal_speed(_horizontal_velocity * direction)

func get_horizontal_speed() -> float:
	return character.get_horizontal_speed()

func set_direction(direction: int) -> void :
	character.set_direction(direction)

func get_direction() -> int:
	return character.get_facing_direction()

func facing_a_wall() -> bool:
	return character.is_colliding_with_wall() == character.get_facing_direction()

func is_colliding_with_wall() -> int:
	return character.is_colliding_with_wall()

func is_on_floor() -> bool:
	return character.is_on_floor()
func is_on_wall() -> bool:
	return character.is_on_wall()

func facing_in_range_for_walljump() -> bool:
	if character.is_in_reach_for_walljump() != 0:
		return character.is_in_reach_for_walljump() == character.get_facing_direction()
	return false

func deactivate_low_jumpcasts() -> void :
	character.deactivate_low_walljump_raycasts()
	
func get_direction_relative(object1, object2 = character) -> int:
	if object1.global_position.x > object2.global_position.x:
		return (1)
	else:
		return ( - 1)

func turn_and_face_player():
	set_direction(get_player_direction_relative())

func face_away_from_player() -> void :
	set_direction( - get_player_direction_relative())

func is_facing_player() -> bool:
	return character.get_facing_direction() == get_player_direction_relative()

func get_player_direction_relative() -> int:
	if GameManager.get_player_position().x > character.global_position.x:
		return (1)
	else:
		return ( - 1)
