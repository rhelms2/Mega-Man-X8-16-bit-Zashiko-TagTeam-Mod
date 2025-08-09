extends Node2D
onready var animated_sprite: AnimatedSprite = $animatedSprite

signal disable_damage

func _ready() -> void:
	animated_sprite.playing = true
	animated_sprite.frame = 0
	Tools.timer(0.1,"disable_damage",self)
	Tools.timer(1.5,"queue_free",self)

func disable_damage() -> void:
	emit_signal("disable_damage")
