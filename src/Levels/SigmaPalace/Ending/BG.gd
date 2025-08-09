extends Sprite

onready var tween: = TweenController.new(self, false)

export  var duration: = 80

func _ready() -> void :
	ascent()

func ascent():
	tween.create(Tween.EASE_OUT, Tween.TRANS_SINE)
	tween.add_attribute("region_rect:position:y", 224, 120.0)
	tween.attribute("modulate", Color.white, 160.0)
	


