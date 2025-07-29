extends Area2D
onready var splash: AnimatedSprite = $splash
onready var splash_2: AnimatedSprite = $splash2
onready var audio: AudioStreamPlayer2D = $audioStreamPlayer2D

func create_splash(sprite) -> void :
	sprite.global_position.x = GameManager.get_player_position().x
	sprite.playing = true
	sprite.frame = 0
	audio.pitch_scale = 0.45 + rand_range( - 0.05, 0.05)
	audio.play()

func _on_area2D_body_entered(_body: Node) -> void :
	create_splash(splash)

func _on_area2D_body_exited(_body: Node) -> void :
	create_splash(splash_2)
