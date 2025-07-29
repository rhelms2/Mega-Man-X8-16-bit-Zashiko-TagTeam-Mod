extends AttackAbility
class_name EnemyWalkTransformed

var walk_message: bool = false
export  var travel_speed: = 70.0

func _StartCondition() -> bool:
	if not character.is_on_floor():
		return false



	if not Input.is_action_pressed(actions[0]) and not Input.is_action_pressed(actions[1]):
		return false
	return true
	
func _EndCondition() -> bool:
	if not character.is_on_floor():
		return true
	if not Input.is_action_pressed(actions[0]) and not Input.is_action_pressed(actions[1]):
		return true
	if Input.is_action_pressed(actions[0]) and Input.is_action_pressed(actions[1]):
		return true
	return false
	
func _Interrupt() -> void :
	walk_message = false
	set_movement_and_direction(0)
	play_animation_once("idle")

func _Update(delta: float) -> void :
	process_gravity(delta)
	if not walk_message:
		walk_message = true

	set_movement_and_direction(travel_speed)
	update_bonus_horizontal_only_conveyor()

