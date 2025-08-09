extends PizzaAbility
class_name PizzaJuggleAndMove

export  var frequency: int = 6

onready var ray_left: RayCast2D = $cast_left
onready var ray_right: RayCast2D = $cast_right
onready var cast_left: RayCast2D = $cast_left2
onready var cast_right: RayCast2D = $cast_right2

var up_and_down: SceneTreeTween
var initial_position: Vector2


func _ready() -> void :
	initial_position = global_position

func _Setup() -> void :
	attack_stage = 0

func _Update(_delta: float) -> void :
	if character.scale.y == - 1:
		process_inverted_gravity(_delta)
	else:
		process_gravity(_delta)
		
	if attack_stage == 0 and has_finished_last_animation():
		play_animation_once("stop")
		activate_touch_damage()
		return_projectile()
		next_attack_stage()
		
	#attack_stage 1 is tween in return_projectile()
		
	elif attack_stage == 2:
		play_animation_once("idle")
# warning-ignore:narrowing_conversion
		force_movement_toward_direction(horizontal_velocity, character.get_direction())
		projectile.position.y = (cos(timer * frequency) * jump_velocity) - 9
		if is_colliding_with_wall() or is_near_ledge() or is_over_range():
			turn()

func is_over_range() -> bool:
	if character.radius == 0:
		return false
	elif character.get_direction() > 0:
		if global_position.x > initial_position.x + character.radius:
			return true
	else:
		if global_position.x < initial_position.x - character.radius:
			return true
	return false

func return_projectile() -> void:
	unhide_projectile()
	projectile.position.y = 13
	var tween = get_tree().create_tween()
	#tween.tween_property(projectile,"position",Vector2(0.0, 0.0),0.5)
	tween.tween_callback(self,"toggle_projectile_damage",[true])
	tween.tween_callback(self,"next_attack_stage")

func is_near_ledge() -> bool:
	return check_for_ledges() == character.get_direction()

func is_colliding_with_wall() -> bool:
	return check_for_walls() == character.get_direction()

func check_for_walls() -> int:
	if cast_left.is_colliding():
		Log("wall to the left")
		return -1
	if cast_right.is_colliding():
		Log("wall to the right")
		return 1
	return 0

func check_for_ledges() -> int:
	if not ray_left.is_colliding():
		Log("ledge to the left")
		return -1
	if not ray_right.is_colliding():
		Log("ledge to the right")
		return 1
	return 0

func process_gravity(_delta: float, gravity: float = default_gravity) -> void :
	character.add_vertical_speed(gravity * _delta)
	if character.get_vertical_speed() > character.maximum_fall_velocity:
		character.set_vertical_speed(character.maximum_fall_velocity)
