extends AnimatedSprite
onready var start_portal: Node2D = $"../StartPortal"


func _ready() -> void :
	if GameManager.has_beaten_the_game():
		visible = true
		play("default")
		start_portal.activate()
	pass
