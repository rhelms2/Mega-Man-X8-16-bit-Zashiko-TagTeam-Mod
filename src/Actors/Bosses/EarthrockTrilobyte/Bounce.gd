extends AttackAbility
class_name TrilobyteBounce

var bounce_direction := 0
var saved_vertical_speed := 0.0
var last_bounce := 0.0
var last_speed := Vector2.ZERO
var bounces = 0
var max_bounces = 0

func _Setup() -> void:
	set_vertical_speed(-jump_velocity)
	saved_vertical_speed = -jump_velocity
	force_movement(horizontal_velocity * bounce_direction)
	#Tools.tween_method(self,"force_movement",s_speed,0.0,0.5)

func _Update(_delta) -> void:
	process_gravity(_delta)
	if is_colliding_with_wall():
		bounce()

	if character.is_on_floor():
		bounce()
		if abs(last_speed.y) < 10:
			EndAbility()

func _Interrupt() -> void:
	Tools.tween_method(self,"force_movement",-character.get_actual_horizontal_speed(),0.0,0.25)

func _on_EnemyShield_guard_broken(projectile) -> void:
	set_bounce_direction(projectile)
	ExecuteOnce()

func set_bounce_direction(projectile) -> void:
	if projectile.global_position.x > character.global_position.x:
		bounce_direction = 1
	else:
		bounce_direction = -1

func get_and_reduce_vertical_speed() -> float:
	saved_vertical_speed = saved_vertical_speed/2
	if abs(saved_vertical_speed) <= 30:
		saved_vertical_speed = 0
	return saved_vertical_speed


func _on_player_detected() -> void:
	if GameManager.get_player_position().y > global_position.y:
		#peleh()
		pass

func peleh() -> void:
	set_vertical_speed(-jump_velocity)
	saved_vertical_speed = jump_velocity
	var s_speed = -character.get_actual_horizontal_speed()
	force_movement_regardless_of_direction(s_speed)

func bounce(horizontal_decay:=2.0, vertical_decay := 1.5) -> void:
	if timer > last_bounce + 0.017:
		last_speed = last_speed.bounce(character.get_slide_collision(0).normal)
		force_movement_regardless_of_direction(last_speed.x/horizontal_decay)
		set_vertical_speed(last_speed.y/vertical_decay)
		bounces += 1
		last_bounce = timer
