extends Sprite

var timer: = 0.0

func _ready() -> void :
	deactivate()

func activate():
	set_physics_process(true)
	
func deactivate():
	set_physics_process(false)

func _physics_process(delta: float) -> void :
	timer += delta * 120
	position.y += sin(timer)
	position.y = clamp(position.y, - 38.25, - 37.75)
