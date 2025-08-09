extends Sprite

onready var tween := TweenController.new(self,false)

func _ready() -> void:
	scale.x = 0
	scale.y = 20
	visible = false

func start():
	visible = true
	self_modulate.a = 1
	scale.x = 0
	tween.reset()
	tween.create(Tween.EASE_IN,Tween.TRANS_CUBIC)
	tween.add_attribute("scale:x",2,.3)
	tween.add_attribute("self_modulate:a",0,1.5)
