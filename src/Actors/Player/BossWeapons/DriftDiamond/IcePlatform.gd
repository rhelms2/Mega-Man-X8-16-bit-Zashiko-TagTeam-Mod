extends Node2D
onready var anim: AnimatedSprite = $animatedSprite
onready var collision: CollisionShape2D = $collision / collisionShape2D
onready var remains_particles: Particles2D = $remains_particles
onready var icebreak: AudioStreamPlayer2D = $icebreak

func _ready() -> void :
	anim.playing = true
	icebreak.play()

func _on_animation_finished() -> void :
	if anim.animation == "start":
		anim.play("idle")
		Tools.timer(2.0, "shatter", self)

func shatter() -> void :
	anim.play("shatter")
	icebreak.pitch_scale = 1
	icebreak.play()
	Tools.timer(2.0, "break_platform", self)

func break_platform() -> void :
	collision.set_deferred("disabled", true)
	icebreak.pitch_scale = 0.85
	icebreak.play()
	remains_particles.emitting = true
	anim.visible = false
	Tools.timer(2.0, "queue_free", self)
