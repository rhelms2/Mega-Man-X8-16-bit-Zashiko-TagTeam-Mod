extends ParallaxBackground
onready var near_bushes: ParallaxLayer = $NearBushes
onready var layers: = get_children()

var moving: = false
var timer: = 0.0

func _physics_process(delta: float) -> void :
	if moving:
		timer += delta
		for l in layers:
			l.motion_offset.x -= delta * 400 * l.motion_scale.x
			l.motion_offset.y += delta * sin(timer) * 200 * l.motion_scale.y

func move() -> void :
	if not moving:
		moving = true
		for l in layers:
			l.motion_offset.y -= 2000 * l.motion_scale.y
		screenshake_periodically()
	
func screenshake_periodically():
	Event.emit_signal("screenshake", 0.7)
	Tools.timer(1.75, "screenshake_periodically", self)


func _on_background_mover_body_entered(_body: Node) -> void :
	move()
