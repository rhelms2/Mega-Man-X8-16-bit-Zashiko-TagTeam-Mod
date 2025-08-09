extends GenericProjectile
#onready var sound: AudioStreamPlayer2D = $sound
onready var hitparticle: Sprite = $"Hit Particle"

var last_speed : Vector2
var last_position : Vector2

func _Update(delta) -> void:
	if is_on_wall() or is_on_floor() or is_on_ceiling():
		bounce()
	
	if timer > 5 or stopped():
		destroy()
		
	last_speed = Vector2(get_horizontal_speed(),get_vertical_speed())
	last_position = global_position
	set_rotation(Vector2(get_horizontal_speed(),get_vertical_speed()).angle())

func set_direction(new_direction):
	facing_direction = new_direction

func stopped() -> bool:
	return last_position == global_position

func bounce() -> void:
	last_speed = last_speed.bounce(get_slide_collision(0).normal)
	set_vertical_speed(last_speed.y)
	set_horizontal_speed(last_speed.x)
	#sound.play()

func _OnHit(_d) -> void:
	set_rotation(0)
	hitparticle.emit()
	disable_visuals()

func _OnScreenExit() -> void: #override
	Log("Exited Screen")
