class_name AnimatedMirror extends AnimatedSprite

export var reference : NodePath
export var copy_position := false
export var copy_scale_x := false
onready var main := get_node(reference)

func _process(_delta: float) -> void:
	if visible:
		animation = main.animation
		frame = main.frame
		if copy_scale_x:
			scale.x = main.scale.x
		if copy_position:
			position = main.position

func hide() -> void:
	visible = false

func unhide() -> void:
	visible = true
