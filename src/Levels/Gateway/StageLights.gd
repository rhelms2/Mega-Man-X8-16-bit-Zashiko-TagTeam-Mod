extends CanvasModulate

onready var tween: = TweenController.new(self, false)

func _ready() -> void :
	Event.listen("darkness", self, "start_darkness")
	Event.listen("turn_off_darkness", self, "end_darkness")
	color = Color.darkgray

func start_darkness():
	
	tween.reset()
	tween.attribute("color", Color.black, 1)
	
func end_darkness():
	
	tween.reset()
	tween.attribute("color", Color.darkgray, 1)
