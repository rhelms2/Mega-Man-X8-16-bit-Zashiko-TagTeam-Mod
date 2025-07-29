extends Line2D

onready var parent: = get_parent()

func _process(_delta: float) -> void :
	default_color = parent.line_color
