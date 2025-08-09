extends WeaponShot

export var wallcheck_distance := 8.0
export var max_time_on_wall := 8.0
onready var area2D = $HittableArea
var timer := 0.0
var adjusted_angle := false

func _ready() -> void:
	area2D.connect("body_entered",self,"_on_area2D_body_entered")

func adjust_angle():
	if not adjusted_angle:
		adjusted_angle = true
		if get_horizontal_speed() > 0:
			animatedSprite.rotate(get_vertical_speed()/330)
		else:
			animatedSprite.rotate(-get_vertical_speed()/330)

func _on_area2D_body_entered(_body: Node) -> void:
	if can_be_hit():
		if  _body.is_in_group("Player Projectile"):
			_body.hit(self)

func raycast(target_position : Vector2) -> Dictionary:
	var space_state = get_world_2d().direct_space_state
	return space_state.intersect_ray(global_position, target_position, [self], collision_mask)

func is_colliding_with_wall() -> int:
	if raycast(Vector2(global_position.x + wallcheck_distance, global_position.y)):
		return 1
	elif raycast(Vector2(global_position.x - wallcheck_distance, global_position.y)):
		return -1
	
	return 0

func is_colliding_with_ceiling() -> bool:
	if raycast(Vector2(global_position.x, global_position.y - wallcheck_distance)):
		return true
	
	return false

func damage(_value, _inflicter = null) -> float:
	current_health -= _value
	return current_health

func _physics_process(delta: float) -> void:
	adjust_angle()
	if timer > 0:
		timer += delta
	if timer == 0:
		if is_colliding_with_wall() != 0 or is_colliding_with_ceiling():
			set_horizontal_speed(0)
			set_vertical_speed(0)
			$HittableArea.scale.y = 1.7
			$particles2D.emitting = false
			timer = 0.01
	if timer > max_time_on_wall:
		emit_hit_particle()
		disable_visual_and_mechanics()
		
	._physics_process(delta)

func emit_hit_particle():
	if not emitted_hit_particle:
		hit_particle.emit(facing_direction)
		emitted_hit_particle = true
		if audio.stream != null:
			audio.play()
