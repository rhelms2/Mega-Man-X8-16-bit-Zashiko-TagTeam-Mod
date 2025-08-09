extends AnimatedSprite

onready var animatedSprite = get_parent()

func _ready() -> void :
	pass


func _process(delta: float) -> void :
	
	
	
	animation = animatedSprite.animation
	frame = animatedSprite.frame
	playing = animatedSprite.playing
	centered = animatedSprite.centered
	offset = animatedSprite.offset
	z_index = 2
	global_position = animatedSprite.global_position
