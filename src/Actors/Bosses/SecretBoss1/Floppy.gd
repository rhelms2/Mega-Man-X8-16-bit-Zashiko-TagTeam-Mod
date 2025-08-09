extends Node2D

onready var sprite: AnimatedSprite = $sprite
onready var tween := TweenController.new(self,false)
onready var light: Sprite = $light
onready var particles_2d: Particles2D = $particles2D

var blinking := false

func _ready() -> void:
	sprite.modulate.a = 0
	light.modulate.a = 0
	particles_2d.emitting = false

func start_blink():
	if not blinking:
		blinking = true
		blink()

func blink():
	if blinking:
		if sprite.modulate.a == 0.75:
			sprite.modulate.a = 0.6
		else:
			sprite.modulate.a = 0.75
		Tools.timer(0.032,"blink",self)
	else:
		sprite.modulate.a = 1.0

func appear():
	start_blink()
	tween.attribute("self_modulate:a",1,.5,sprite)
	tween.attribute("modulate:a",1,.5,light)
	particles_2d.emitting = true

func disappear():
	blinking = false
	tween.attribute("self_modulate:a",0,.25,sprite)
	tween.attribute("modulate:a",0,.25,light)
	particles_2d.emitting = false

