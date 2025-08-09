extends Node2D

onready var tween := TweenController.new(self,false)
onready var collider: CollisionShape2D = $VoidDeathPlane/area2D/collisionShape2D
onready var feather_decay: Particles2D = $feather_decay
onready var visuals: Node2D = $visuals

func activate():
	visible = true
	move_towards_center()

func move_towards_center():
	tween.attribute("position:x",position.x - (210) * scale.x,36)

func deactivate():
	collider.set_deferred("disabled",true)
	feather_decay.emitting = true
	tween.reset()
	tween.create(Tween.EASE_OUT, Tween.TRANS_CUBIC)
	tween.attribute("position:x",position.x + (64) * scale.x,2)
	tween.attribute("modulate:a",0.0,2.0,visuals)
