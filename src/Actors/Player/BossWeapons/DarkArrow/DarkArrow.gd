extends SimplePlayerProjectile
const bypass_shield: = true
const speed: = 420.0
const turn_amount: = 0.01
onready var tracker: Area2D = $tracker
var target: Node2D
var track_timer: = 0.0
export  var tracking_time: = 0.4
export  var tracker_update_interval: = 0.05

func _Setup() -> void :
	._Setup()
	set_horizontal_speed(speed * get_facing_direction())

func _Update(delta: float) -> void :
	if has_hit_scenery():
		on_wall_hit()
		return
	else:
		set_rotation(Vector2(get_horizontal_speed(), get_vertical_speed()).angle())
	._Update(delta)
	go_after_nearest_target(delta)
	if timer > 0.3 and not ending:
		process_gravity(delta * 0.85)

func on_wall_hit() -> void :
	animatedSprite.visible = true
	if is_collided_moving():
		disable_visuals()
		return
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

func set_direction(new_direction) -> void :
	Log("Seting direction: " + str(new_direction))
	facing_direction = new_direction

func deflect(_var) -> void :
	pass

func _OnHit(_v) -> void :
	._OnHit(_v)
	ending = true

func deactivate() -> void :
	.deactivate()
	modulate = Color(1, 1, 1, 0.5)
	stop()
	disable_damage()
	ending = true
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(0, 0, 1, 0), 2)
	tween.tween_callback(self, "destroy")

func angle_to_vector2(angle) -> Vector2:
	return Vector2(cos(angle), sin(angle))
	
