extends Sprite

onready var tween_brightness := TweenController.new(self,false)
onready var spriteflash: AnimatedSprite = $"../spriteflash"

func start() -> void:
	spriteflash.frame = 0
	visible = true
	scale.y = 5
	modulate = Color(1,1,1,0.25)
	tween_brightness.create()
	tween_brightness.set_parallel()
	tween_brightness.set_ignore_pause_mode()
	tween_brightness.add_attribute("modulate",Color(0.75,0.6,0.9,0.0),0.25)
	tween_brightness.add_attribute("scale:y",0.5,0.25)
