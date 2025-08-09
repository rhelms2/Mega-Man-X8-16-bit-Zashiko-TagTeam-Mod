extends GenericProjectile
var speed := 170.0
export var tracker_update_interval := 0.02
export var transform_time := 1.5
var last_dir := Vector2(0,0)
var emitted := false
onready var hitparticle: Sprite = $"Hit Particle"

 
signal guard_break 
 
signal shield_hit

func initialize(_direction) -> void: #called from instantiator
	Log("Initializing")
	activate()
	reset_timer()
	_Setup()

# warning-ignore:unused_argument
func _Update(delta) -> void:
	
	if is_on_floor() or is_on_wall() or is_on_ceiling():
		explode()
		return
	
	if attack_stage == 0:
		var target_dir = Tools.get_player_angle(global_position)
		var target_speed = Vector2(speed * target_dir.x,speed * target_dir.y)
		slowly_turn_towards_target(target_speed)
		set_rotation(Vector2(get_horizontal_speed(),get_vertical_speed()).angle())
		if timer > transform_time:
			next_attack_stage()

	elif attack_stage == 1:
		animatedSprite.play("transform")
		set_horizontal_speed(last_dir.x * speed/4)
		set_vertical_speed(last_dir.y * speed/4)
		next_attack_stage()

	elif attack_stage == 2 and timer > 0.25:
		animatedSprite.play("speed")
		set_horizontal_speed(last_dir.x * speed * 4)
		set_vertical_speed(last_dir.y * speed * 4)
		next_attack_stage()

func _OnHit(_target_remaining_HP) -> void: #override
	if not emitted: 
		explode()

func explode() -> void:
	#	explosion_sound.play()
		disable_visuals()
		deactivate()
		emitted = true
		set_rotation(0)
		hitparticle.emit()

func slowly_turn_towards_target(target_speed : Vector2) -> void:
	var current_speed = Vector2(get_horizontal_speed(),get_vertical_speed())
	var current_angle = current_speed.normalized().angle()
	var target_angle = target_speed.normalized().angle()
	var new_angle = lerp_angle(current_angle,target_angle, tracker_update_interval)
	var new_speed = angle_to_vector2(new_angle)
	
	set_horizontal_speed(new_speed.x * speed)
	set_vertical_speed(new_speed.y * speed)
	last_dir = new_speed

func angle_to_vector2 (angle) -> Vector2:
	return Vector2(cos(angle), sin(angle))

func _on_guard_break() -> void:
	explode()
	pass # Replace with function body.
