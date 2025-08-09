extends GenericProjectile
onready var sound: AudioStreamPlayer2D = $sound
onready var rastro: Sprite = $rastro

var last_speed : Vector2
var last_position : Vector2
var rastro_timer := 0.0
const rastro_interval := 0.075
onready var line_2d: Line2D = $trail/line2D

func _Update(delta) -> void:
	rastro_timer += delta
	if animatedSprite.visible and rastro_timer > rastro_interval:
		emit_rastro(true)
		
	if is_on_wall() or is_on_floor() or is_on_ceiling():
		bounce()
	
	if timer > 5 or stopped():
		destroy()
		
	last_speed = Vector2(get_horizontal_speed(),get_vertical_speed())
	last_position = global_position

func stopped() -> bool:
	return last_position == global_position

func disable_visuals():
	emit_rastro()
	line_2d.visible = false
	.disable_visuals()

func emit_rastro(reset_rtimer := false) ->void:
	rastro.emit()
	if reset_rtimer:
		rastro_timer = 0

func bounce() -> void:
	last_speed = last_speed.bounce(get_slide_collision(0).normal)
	var random := rand_range(-PI/8,PI/8)
	last_speed = last_speed.rotated(random)
	set_vertical_speed(last_speed.y)
	set_horizontal_speed(last_speed.x)
	sound.play_rp()
