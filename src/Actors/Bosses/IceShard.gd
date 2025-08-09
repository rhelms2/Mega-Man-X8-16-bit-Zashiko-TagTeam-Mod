extends WeaponShot

onready var area2D = $area2D
var timer := 0.0
var time_blinking := 0.0

func _ready() -> void:
	area2D.connect("body_entered",self,"_on_area2D_body_entered")
	area2D.connect("body_exited",self,"_on_area2D_body_exited")

func _physics_process(delta: float) -> void:
	var rotate_speed := (delta * 8)
	animatedSprite.rotate(rotate_speed)
	timer += delta
	if timer > time_blinking + 0.05:
		animatedSprite.material.set_shader_param("Flash", 0)
		
	set_horizontal_speed(horizontal_velocity * cos(timer * 3))

func projectile_setup(direction:int, _spawn_point:Vector2, launcher_velocity := 0.0):
	references_setup(direction)
	launch_setup(direction, launcher_velocity)
	play_fire_sound()

func _on_area2D_body_entered(_body: Node) -> void:
	if can_be_hit():
		if  _body.is_in_group("Player Projectile"):
			_body.hit(self)
			
func _on_area2D_body_exited(_body: Node) -> void:
	if can_be_hit():
		if  _body.is_in_group("Player Projectile"):
			_body.leave(self)

func damage(value, _inflicter = null) -> float:
	current_health -= value
	animatedSprite.material.set_shader_param("Flash", 1)
	time_blinking = timer
	return current_health

func emit_hit_particle():
	if not emitted_hit_particle:
		hit_particle.emit(facing_direction)
		emitted_hit_particle = true
		if audio.stream != null:
			audio.play()
