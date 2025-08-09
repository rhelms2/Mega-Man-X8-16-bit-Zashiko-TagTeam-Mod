extends AnimatedSprite
onready var line: Line2D = $line
onready var collision: AnimatedSprite = $collision

export var line_frames : Array

func _physics_process(_delta: float) -> void:
	collision.frame = frame
	line.texture = line_frames[frame]

