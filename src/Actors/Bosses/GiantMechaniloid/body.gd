extends AnimatedSprite

onready var parent: AnimatedSprite = $".."

func _process(delta: float) -> void:
	animation = parent.animation
	frame = parent.frame
