extends Movement
class_name Walk

var minimum_time := 0.02
var starting_from_stop := false

export var shot_pos_adjust := Vector2 (6,-2)
func get_shot_adust_position() -> Vector2:
	return shot_pos_adjust

func _ready() -> void:
# warning-ignore:return_value_discarded
	character.get_node("animatedSprite").connect("animation_finished", self, "_on_animatedSprite_animation_finished")

func _StartCondition() -> bool:
	if not character.is_on_floor():
		return false
	if character.is_colliding_with_wall() != 0:
		if character.is_colliding_with_wall_except_feet() == get_pressed_direction():
			return false
	if get_pressed_direction() == 0:
		return false
			
	return true
	
func _Setup() -> void:
	Event.emit_signal("walk", get_pressed_direction())
	starting_from_stop = character.get_last_used_ability() == "Idle"
	deactivate_low_jumpcasts()
	
func _Interrupt() -> void:
	character.set_vertical_speed(0)

func _Update(_delta: float) -> void:
	if timer < 0.08 and starting_from_stop:
		set_movement_and_direction(horizontal_velocity/4)
	else:
		set_movement_and_direction(horizontal_velocity)
	update_bonus_horizontal_only_conveyor()

func _EndCondition() -> bool:
	if not character.is_on_floor():
		return true
	
	if character.is_colliding_with_wall() != 0:
		if character.is_colliding_with_wall_except_feet() == get_pressed_direction():
			return true

	if timer > minimum_time and get_pressed_direction() == 0:
		return true
	
	return false

func _on_animatedSprite_animation_finished() -> void:
	if executing:
		if (character.get_animation() == "walk_start"):
			character.play_animation("walk")

func play_animation_on_initialize():
	if character.get_last_used_ability() == "Idle":
		character.play_animation("walk_start")
	else:
		character.play_animation(animation)

func should_execute_on_hold() -> bool:
	return true
