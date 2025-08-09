extends SimplePlayerProjectile
onready var sound: AudioStreamPlayer2D = $sound
onready var rastro: Sprite = $rastro

var last_speed: Vector2
var last_position: Vector2
var rastro_timer: = 0.0
const rastro_interval: = 0.025
onready var line_2d: Line2D = $trail / line2D

var on_ground: bool = false

func _Update(delta: float) -> void :
	rastro_timer += delta
	if animatedSprite.visible and rastro_timer > rastro_interval:
		rastro.emit()
		rastro_timer = 0
	if not animatedSprite.visible and timer > pop_in_time and not ending:
		enable_visuals()
		
	if is_on_wall() or is_on_floor() or is_on_ceiling():
		bounce()
	
	if timer > 2 or stopped():
		destroy()
		
	last_speed = Vector2(get_horizontal_speed(), get_vertical_speed())
	last_position = global_position

func stopped() -> bool:
	return last_position == global_position

func disable_visuals():
	rastro.emit()
	line_2d.visible = false
	.disable_visuals()

func bounce() -> void :
	last_speed = last_speed.bounce(get_slide_collision(0).normal)
	var random: = rand_range( - PI / 8, PI / 8)
	last_speed = last_speed.rotated(random)
	set_vertical_speed(last_speed.y)
	set_horizontal_speed(last_speed.x)
	sound.play_rp(0.05, 2.0)
	update_facing_direction()

func update_facing_direction() -> void :
	if get_horizontal_speed() > 0:
		set_direction(1)
	else:
		set_direction( - 1)

