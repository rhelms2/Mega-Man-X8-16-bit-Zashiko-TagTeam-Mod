extends Node2D
onready var sprite: AnimatedSprite = $"../animatedSprite"
onready var slash_hitbox: Node2D = $SlashHitbox

func _physics_process(_delta: float) -> void :
	if sprite.frame == 3:
		slash_hitbox.activate()
	else:
		slash_hitbox.deactivate()
