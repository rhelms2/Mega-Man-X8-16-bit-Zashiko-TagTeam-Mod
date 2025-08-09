extends Node2D
onready var damage: Node2D = $DamageOnTouch
onready var animation: AnimatedSprite = $animatedSprite


func _ready() -> void:
	visible = false

func activate():
	visible = true
	damage.activate()
	animation.play("cannon_loop")
	animation.frame = 0

func deactivate():
	damage.deactivate()
	animation.play("cannon_end")
	Tools.timer_p(1,"set_visible",self,false)
