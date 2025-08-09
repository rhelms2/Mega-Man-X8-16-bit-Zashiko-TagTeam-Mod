extends AnimatedSprite

var head_frames : SpriteFrames
export var head_l_frames : SpriteFrames

func _ready() -> void:
	head_frames = frames

func _process(_delta: float) -> void:
	adjust_head_frames()

func adjust_head_frames() -> void:
	if scale.x > 0 and frames != head_l_frames:
		frames = head_l_frames
	elif scale.x < 0 and frames != head_frames:
		frames = head_frames
