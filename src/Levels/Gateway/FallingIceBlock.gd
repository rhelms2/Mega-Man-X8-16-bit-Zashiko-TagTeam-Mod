extends KinematicBody2D

onready var tween: = TweenController.new(self, false)
onready var particles: Particles2D = $particles2D

export  var fall_on_touch: = false
var falling: = false

func activate():
	if not falling:
		falling = true
		fall()
	

func fall():
	particles.emitting = false
	tween.create(Tween.EASE_IN, Tween.TRANS_CUBIC)
	tween.add_attribute("position:y", position.y + 256, 2.0)
	tween.add_callback("queue_free")

func _on_body_entered(_body: Node) -> void :
	if fall_on_touch:
		Tools.timer(0.3, "activate", self)
