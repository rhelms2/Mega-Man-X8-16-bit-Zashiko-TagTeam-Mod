extends Node2D

onready var sprites: Array

func _ready() -> void :
	for child in get_children():
		if child is AnimatedSprite:
			sprites.append(child)

	decide_next_animation()

func _on_animation_finished() -> void :
	Tools.timer(rand_range(0.1, 0.5), "decide_next_animation", self)

func decide_next_animation():
	var next_animation = rand_range(0, 3)
	
	if next_animation < 1:
		play_animation("1")
	elif next_animation >= 1 and next_animation < 2:
		play_animation("2")
	else:
		play_animation("3")

func play_animation(anim: String):
	var speed = rand_range(0.7, 1)
	var alpha = rand_range(0.1, 0.5)
	for animatedSprite in sprites:
		animatedSprite.play(anim)
		animatedSprite.speed_scale = speed
		animatedSprite.modulate.a = alpha
