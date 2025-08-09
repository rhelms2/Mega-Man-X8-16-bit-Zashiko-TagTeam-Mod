extends Node2D

signal opened
onready var sprite: AnimatedSprite = $animatedSprite
onready var explosion_particles: Particles2D = $explosion_particles
onready var remains_particles: Particles2D = $remains_particles

var emitted_signal: = false

func _on_area2D_body_entered(body: Node) -> void :
	if "SqueezeBomb" in body.name and not emitted_signal:
		emit_signal("opened")
		emitted_signal = true
		sprite.material.set_shader_param("Alpha_Blink", 1)
		sprite.playing = false
		explosion_particles.emitting = true
		Tools.timer(1.0, "hide_and_emit_remains", self)
	elif not emitted_signal:
		body.deflect(self)

func hide_and_emit_remains():
	explosion_particles.emitting = false
	remains_particles.emitting = true
	sprite.visible = false
	Tools.timer(2, "queue_free", self)

func deactivate():
	if not emitted_signal:
		emitted_signal = true
		sprite.playing = false
		sprite.material.set_shader_param("Alpha_Blink", 1)
