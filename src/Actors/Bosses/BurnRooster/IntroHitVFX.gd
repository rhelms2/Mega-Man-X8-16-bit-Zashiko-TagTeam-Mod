extends Node2D

onready var animated_sprite: AnimatedSprite = $"../animatedSprite"
onready var hit: AudioStreamPlayer2D = $hit
onready var particles: Particles2D = $particles2D
onready var flash: Sprite = $flash

var frames = [5,14,23]

var waiting := false

func _physics_process(delta: float) -> void:
	if animated_sprite.animation == "appear_loop":
		particles.emitting = true
		for frame in frames:
			if not waiting and animated_sprite.frame == frame:
				hit.play_rp()
				flash.start()
				flash.rotation_degrees = rand_range(-15,15)
				waiting = true
				Tools.timer(0.1,"unwait",self)
				pass
	else:
		particles.emitting = false
		set_physics_process(false)

func unwait():
	waiting = false
