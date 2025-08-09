extends SimplePlayerProjectile
onready var left_tracker: Area2D = $left_tracker
onready var right_tracker: Area2D = $right_tracker
var tracking: bool = false

const bypass_shield: = true

func get_target_from_facing_direction_first() -> Node2D:
	var first_check
	var second_check
	if get_facing_direction() > 0:
		first_check = right_tracker
		second_check = left_tracker
	else:
		first_check = left_tracker
		second_check = right_tracker

	var target = first_check.get_closest_target()
	
	
	return target

func track():
	var target = get_target_from_facing_direction_first()
	if target:
		var dir: = Tools.get_angle_between(target, self)
		set_horizontal_speed(420 * dir.x)
		set_vertical_speed(420 * dir.y)
		set_rotation(Vector2(get_horizontal_speed(), get_vertical_speed()).angle())
	else:
		set_horizontal_speed(420 * get_facing_direction())
		set_rotation(Vector2(get_horizontal_speed(), get_vertical_speed()).angle())
	tracking = true

func _Update(delta: float) -> void :
	._Update(delta)
	if not tracking:
		track()

func _OnHit(_target_remaining_HP) -> void :
	pass

func deflect(_var) -> void :
	pass

func set_direction(new_direction) -> void :
	Log("Seting direction: " + str(new_direction))
	facing_direction = new_direction

