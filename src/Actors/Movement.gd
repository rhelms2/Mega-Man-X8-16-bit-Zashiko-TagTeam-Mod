extends Ability
class_name Movement

var default_gravity: float = 900.0
const jumpcast_activation_time: float = 0.05

export  var horizontal_velocity: float = 90.0
export  var jump_velocity: float = 320.0

var changed_animation: bool = false
var jump_plus_ground_velocity: float = jump_velocity
var horizontal_plus_ground_velocity: float = horizontal_velocity
var jumpcast_timer: float = 0.0


func Initialize() -> void :
	.Initialize()
	jump_plus_ground_velocity = get_jump_velocity() - character.get_floor_velocity().y
	horizontal_plus_ground_velocity = get_horizontal_velocity() + character.get_floor_velocity().x * character.get_direction()

func get_horizontal_velocity() -> float:
	return horizontal_velocity

func get_jump_velocity() -> float:
	return jump_velocity

func get_effective_speed(_speed) -> float:
	if character.time_stop_active:
		if Engine.time_scale < 1.0:
			return _speed / Engine.time_scale
	return _speed

func process_gravity(delta: float, gravity: float = default_gravity) -> void :
	var _gravity = get_effective_speed(gravity)
	var max_velocity = get_effective_speed(character.maximum_fall_velocity)
	var original_delta = delta / Engine.time_scale
	character.add_vertical_speed(gravity * delta)
	
	if character.get_vertical_speed() > character.maximum_fall_velocity:
		character.set_vertical_speed(character.maximum_fall_velocity)

func process_inverted_gravity(_delta: float, gravity: float = - default_gravity) -> void :
	var _gravity = get_effective_speed(gravity)
	character.add_vertical_speed(gravity * _delta)

func set_movement_no_direction(_horizontal_velocity: float, _delta: float = 0.016) -> void :
	var _horizontal_velo = get_effective_speed(_horizontal_velocity)
	character.set_horizontal_speed(_horizontal_velo * get_pressed_direction())

func set_movement_and_direction(_horizontal_velocity: float, _delta: float = 0.016) -> void :
	var _horizontal_velo = get_effective_speed(_horizontal_velocity)
	set_direction_as_pressed_direction()
	character.set_horizontal_speed(_horizontal_velo * character.get_direction())

func set_movement_and_direction_plus_ground_speed(_horizontal_velocity: float, _delta: float = 0.016) -> void :
	var _horizontal_velo_plus_ground = get_effective_speed(horizontal_plus_ground_velocity)
	set_direction_as_pressed_direction()
	character.set_horizontal_speed(_horizontal_velo_plus_ground * character.get_direction())

func update_bonus_horizontal_only_conveyor(extra: float = 0.0) -> void :
	if character.is_on_floor():
		var conveyor_belt = character.get_conveyor_belt_speed()
		var speed = conveyor_belt + extra
		var _effective_speed = get_effective_speed(speed)
		character.set_bonus_horizontal_speed(speed)

func update_bonus_horizontal_speed(extra: float = 0.0) -> void :
	var ground = character.get_floor_velocity().x
	var conveyor_belt = character.get_conveyor_belt_speed()
	var speed = ground + conveyor_belt + extra
	var _effective_speed = get_effective_speed(speed)
	character.set_bonus_horizontal_speed(_effective_speed)

func decay_bonus_horizontal_speed(rate: float = 0.975) -> void :
	var bonus_speed: = character.get_bonus_horizontal_speed()
	bonus_speed = bonus_speed * rate
	var _effective_speed = get_effective_speed(bonus_speed)
	character.set_bonus_horizontal_speed(_effective_speed)

func zero_bonus_horizontal_speed() -> void :
	character.set_bonus_horizontal_speed(0)

func set_vertical_speed(_jump_velocity: float, snap: bool = true) -> void :
	var _effective_speed = get_effective_speed(_jump_velocity)
	character.set_vertical_speed(_jump_velocity, snap)

func get_vertical_speed() -> float:
	return character.get_vertical_speed()

func force_movement(_horizontal_velocity: float) -> void :
	var _effective_speed = get_effective_speed(_horizontal_velocity)
	character.set_horizontal_speed(_effective_speed * character.get_facing_direction())

func force_movement_regardless_of_direction(_horizontal_velocity: float) -> void :
	var _effective_speed = get_effective_speed(_horizontal_velocity)
	character.set_horizontal_speed(_effective_speed)

func set_horizontal_speed(_horizontal_velocity: float) -> void :
	var _effective_speed = get_effective_speed(_horizontal_velocity)
	character.set_horizontal_speed(_effective_speed)

func increment_movement_regardless_of_direction(_horizontal_velocity: float) -> void :
	var _effective_speed = get_effective_speed(_horizontal_velocity)
	character.add_horizontal_speed(_effective_speed)

func force_movement_toward_direction(_horizontal_velocity: float, direction: int) -> void :
	var _effective_speed = get_effective_speed(_horizontal_velocity)
	character.set_horizontal_speed(_effective_speed * direction)

func set_direction(direction: int, update: bool = false) -> void :
	character.set_direction(direction, update)

func set_direction_as_pressed_direction() -> void :
	character.set_direction(get_pressed_direction())

func facing_a_wall() -> bool:
	return character.is_colliding_with_wall() == character.get_facing_direction()

func get_facing_direction() -> int:
	return character.get_facing_direction()

func pressing_towards_wall() -> bool:
	if character.is_colliding_with_wall() != 0:
		return character.is_colliding_with_wall() == get_pressed_direction()
	return false

func facing_in_range_for_walljump() -> bool:
	if character.is_in_reach_for_walljump() != 0:
		return character.is_in_reach_for_walljump() == character.get_facing_direction()
	return false

func change_animation_if_falling(animation: String) -> void :
	if not changed_animation:
		if character.get_animation() != "fall":
			if character.get_vertical_speed() > 0:
				character.play_animation(animation)
				changed_animation = true
				set_shot_position_during_fall()

func set_shot_position_during_ascencion() -> void :
	pass

func set_shot_position_during_fall() -> void :
	pass

func change_animation(animation: String) -> void :
	character.play_animation(animation)

func _Interrupt() -> void :
	character.set_horizontal_speed(0)
	character.set_vertical_speed(0)
	zero_bonus_horizontal_speed()

func dash_input_not_too_long_ago(last_dashed_leeway: float) -> bool:
	return get_time() - character.last_time_dashed < last_dashed_leeway * 1000

func on_dash_press() -> void :
	character.last_time_dashed = get_time()

func on_touch_floor() -> void :
	pass

func deactivate_low_jumpcasts() -> void :
	character.deactivate_low_walljump_raycasts()

func activate_low_jumpcasts_after_delay(delta: float) -> void :
	if not character.are_low_walljump_raycasts_active():
		jumpcast_timer += delta
		if jumpcast_timer > jumpcast_activation_time:
			character.activate_low_walljump_raycasts()
			jumpcast_timer = 0
