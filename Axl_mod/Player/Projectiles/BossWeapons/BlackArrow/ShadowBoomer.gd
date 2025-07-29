extends BossWeaponAxl

const bypass_shield: bool = true
const turn_amount: float = 0.01
const speed: float = 350.0

onready var loop: AudioStreamPlayer2D = $loop

var target: Node2D
var timer: float = 0.0
var time_alive: float = 0.0

var return_started: bool = false
var orbit: float = 2
var player_threshold: int = 16
var rotation_speed: int = 40
var curve_direction: int = - 1

var items: Array = []


func launch_setup(_direction, _launcher_velocity: float = 0.0):
	play_sound(fire_sound, 0, true)
	loop.play()
	set_horizontal_speed(horizontal_velocity)
	set_vertical_speed(vertical_velocity)
	set_rotation(Vector2(get_horizontal_speed(), get_vertical_speed()).angle())
	position += Vector2(get_horizontal_speed(), get_vertical_speed()).normalized() * 5
	var facing = get_facing_direction()
	if vertical_velocity < 0:
		curve_direction = - facing
	else:
		curve_direction = facing

func _on_tracker_body_entered(body: Node) -> void :
	var item = body.get_parent()
	if item is PickUp or item is LifeUp:
		if "expirable" in item:
			item.expirable = false
		
		items.append(body.get_parent())

func _physics_process(delta: float) -> void :
	animatedSprite.rotation_degrees += rotation_speed * curve_direction
	time_alive += delta
	if time_alive >= 0.1 and not return_started:
		return_started = true
	if return_started:
		if orbit < 8:
			orbit *= 1.04
		else:
			orbit = 8
		come_back_to_player(delta)
		
	if items:
		for item in items:
			if is_instance_valid(item):
				countdown_to_destruction = 0.0
				item.position = position
		
	._physics_process(delta)

func come_back_to_player(delta: float) -> void :
	if return_started and not target:
		target = GameManager.player
	if is_tracking_player():
		var target_dir = Tools.get_angle_between(target, self)
		var target_speed = Vector2(speed * target_dir.x, speed * target_dir.y)
		slowly_turn_towards_player(target_speed, delta)
		if abs(target.global_position.x - global_position.x) < player_threshold and abs(target.global_position.y - global_position.y) < player_threshold:
			
			if time_alive >= 1.0:
				destroy()
				loop.stop()

func is_tracking_player() -> bool:
	if is_instance_valid(target):
		if target.name == "actual_center":
			if target.get_parent().current_health > 0:
				return true
		elif target.current_health > 0:
			return true
		else:
			target = null
	return false

func slowly_turn_towards_player(target_speed: Vector2, delta: float) -> void :
	var current_speed = Vector2(get_horizontal_speed(), get_vertical_speed())
	var current_angle = current_speed.normalized().angle()
	var curve_offset = deg2rad(12) * curve_direction
	var target_angle = target_speed.normalized().angle() + curve_offset
	var new_angle = lerp_angle(current_angle, target_angle, delta * orbit)
	var new_speed = angle_to_vector2(new_angle)
	set_horizontal_speed(new_speed.x * speed)
	set_vertical_speed(new_speed.y * speed)

func angle_to_vector2(angle) -> Vector2:
	return Vector2(cos(angle), sin(angle))

func deflect(_var) -> void :
	pass

func emit_hit_particle():
	pass

func disable_projectile_visual():
	pass

func disable_particle_visual():
	pass

func _OnHit(_v) -> void :
	pass

func hit(_body) -> void :
	_body.damage(damage, self)
	emit_signal("hit")
	
func activate() -> void :
	active = true
	
func deactivate() -> void :
	active = false
