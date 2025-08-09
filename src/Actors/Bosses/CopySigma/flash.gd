extends Sprite

onready var tween := TweenController.new(self,false)

func _ready() -> void:
	modulate.a = 0.0

func start():
	modulate = Color(2,2,2,1)
	var color = Color.fuchsia
	color.a = 0
	tween.attribute("modulate",color)
