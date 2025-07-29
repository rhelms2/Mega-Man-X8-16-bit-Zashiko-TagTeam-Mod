extends BossWeaponAxl

const bypass_shield: bool = true
const speed: float = 420.0
const turn_amount: float = 0.01

export  var tracking_time: float = 0.75
export  var tracker_update_interval: float = 0.2
export  var pop_in_time: float = 0.032

onready var tracker: Area2D = $tracker

var target: Node2D
var track_timer: float = 0.0
var ending: bool = false
var timer: float = 0.0
var time_alive: float = 0.0


func launch_setup(_direction, _launcher_velocity: float = 0.0) -> void :
	play_fire_sound()
	if get_facing_direction() > 0:
		get_node("animatedSprite").rotation = deg2rad(0)
	else:
		get_node("animatedSprite").rotation = deg2rad(180)
	set_horizontal_speed(horizontal_velocity * rand_range(0.9, 1.1))
	set_vertical_speed(vertical_velocity * rand_range(0.9, 1.1))
	set_rotation(Vector2(get_horizontal_speed(), get_vertical_speed()).angle())

func _physics_process(delta: float) -> void :
	time_alive += delta
	if time_alive >= 3:
		ending = true
	if not ending:
		if has_hit_scenery():
			on_wall_hit()
			return
		set_rotation(Vector2(get_horizontal_speed(), get_vertical_speed()).angle())
	if not animatedSprite.visible and timer > pop_in_time and not ending:
		enable_visuals()
	if ending and timer > 1:
		destroy()
	go_after_nearest_target(delta)
	if not ending:
		process_gravity(delta * 0.85)
	._physics_process(delta)

func on_wall_hit() -> void :
	animatedSprite.visible = true
	deactivate()

func go_after_nearest_target(delta: float) -> void :
	if not ending and not target:
		track_timer += delta
		if track_timer > tracker_update_interval:
			target = tracker.get_closest_target()
			track_timer = 0
			if target:
				Log("target: " + target.name)
	if is_tracking():
		var target_dir = Tools.get_angle_between(target, self)
		var target_speed = Vector2(speed * target_dir.x, speed * target_dir.y)
		slowly_turn_towards_target(target_speed, delta)

func slowly_turn_towards_target(target_speed: Vector2, delta: float) -> void :
	var current_speed = Vector2(get_horizontal_speed(), get_vertical_speed())
	var current_angle = current_speed.normalized().angle()
	var target_angle = target_speed.normalized().angle()
	var new_angle = lerp_angle(current_angle, target_angle, delta * 10)
	var new_speed = angle_to_vector2(new_angle)
	set_horizontal_speed(new_speed.x * speed)
	set_vertical_speed(new_speed.y * speed)

func is_tracking() -> bool:
	if timer > tracking_time or ending:
		return false
	if is_instance_valid(target):
		if target.name == "actual_center":
			if target.get_parent().current_health > 0:
				return true
		elif target.current_health > 0:
			return true
		else:
			target = null
	return false

func deflect(_var) -> void :
	pass

func emit_hit_particle() -> void :
	pass

func disable_projectile_visual() -> void :
	pass

func disable_particle_visual() -> void :
	pass

func _OnHit(_v) -> void :
	pass

func hit(_body) -> void :
	_body.damage(damage, self)
	emit_signal("hit")
	active = false
	stop()
	disable_damage()
	ending = true
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(0, 0, 1, 0), 0.25)
	tween.tween_callback(self, "destroy")

func deactivate() -> void :
	active = false
	stop()
	disable_damage()
	ending = true
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 1)
	tween.tween_callback(self, "destroy")

func angle_to_vector2(angle) -> Vector2:
	return Vector2(cos(angle), sin(angle))
