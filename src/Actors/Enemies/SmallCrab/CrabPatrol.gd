extends AttackAbility
class_name CrabPatrol

var initial_position := Vector2.ZERO
export var random_turn := true
export var travel_time := 1.25
export var travel_speed := 70.0
export var rest_time := 0.8

func _ready() -> void:
	initial_position = global_position
	
func _Setup() -> void:
	attack_stage = 0
	if random_turn:
		var move_direction = random_n()
		set_direction(move_direction)
		set_movement_and_turn(move_direction, travel_speed)
	else:
		turn()
		Tools.timer(0.05,"move",self)
	random_rest_time()

func move() -> void:
	if executing:
		character.update_facing_direction()
		force_movement(travel_speed)

func set_movement_and_turn(move_direction, _travel_speed) -> void:
	set_direction(move_direction)
	force_movement_toward_direction(_travel_speed, move_direction)

func _Update(delta) -> void:
	process_gravity(delta)
	if attack_stage == 0: #andando
		if is_colliding_with_wall_with_vertical_correction(0):
			set_movement_and_turn(-character.get_facing_direction(), travel_speed)
	
		if timer > travel_time:
			force_movement(0)
			play_animation("idle")
			next_attack_stage()

	if attack_stage == 1 and timer > rest_time: #parado
		EndAbility()

func is_colliding_with_wall_with_vertical_correction(vertical_correction := 0) -> bool:
	return character.is_colliding_with_wall(13, vertical_correction) == character.get_direction()

func random_n() -> int:
	var rng = randi() % 2
	if rng == 0:
		rng = -1
	return rng

func random_rest_time() -> void:
	rest_time = 0.8 + randf()
