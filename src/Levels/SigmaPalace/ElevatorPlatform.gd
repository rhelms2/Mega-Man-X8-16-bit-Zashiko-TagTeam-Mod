extends Sprite

var timer: = 0.0
onready var loop: AudioStreamPlayer2D = $loop
onready var tween: = TweenController.new(self, false)

func _ready() -> void :
	activate()

func activate():
	set_physics_process(true)
	tween.attribute("volume_db", - 30, 6, loop)
	
func deactivate():
	set_physics_process(false)

func _physics_process(delta: float) -> void :
	timer += delta * 120
	position.y += sin(timer)
	position.y = clamp(position.y, 163.25, 163.85)
