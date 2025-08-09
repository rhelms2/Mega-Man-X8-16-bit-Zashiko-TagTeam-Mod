extends TextureRect

onready var tween := TweenController.new(self,false)

func _ready() -> void:
	Savefile.connect("saved",self,"display")
	modulate.a = 0.0

func display():
	tween.reset()
	tween.attribute("modulate:a",0.5,.1)
	tween.add_attribute("modulate:a",0,0.75)
	
