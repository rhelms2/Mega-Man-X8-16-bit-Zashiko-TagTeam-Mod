extends Node


onready var physics = Physics.new(get_parent())
onready var animation = AnimationController.new($"../animatedSprite",false)

func _physics_process(delta: float) -> void:
	if physics.get_vertical_speed() < 0:
		animation.play("armor_up")
	elif physics.get_vertical_speed() > 0:
		animation.play("armor_fall")
	else:
		animation.play("armor_idle")
