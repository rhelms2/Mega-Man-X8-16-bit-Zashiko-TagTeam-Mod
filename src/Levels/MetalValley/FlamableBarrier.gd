extends Node2D

onready var collision: CollisionShape2D = $staticBody2D / collisionShape2D
onready var explosion: Particles2D = $"Explosion Particles"
onready var fire: Particles2D = $Fire
onready var tile_map: TileMap = $tileMap
export  var disabled: = false
onready var sound: AudioStreamPlayer2D = $explosion
onready var remains_particles: Particles2D = $remains_particles

func deactivate() -> void :
	collision.disabled = true
	disabled = true


func _on_projectile_detected() -> void :
	if not disabled:
		call_deferred("deactivate")
		explosion.emitting = true
		remains_particles.emitting = true
		fire.emitting = true
		sound.play()
		tile_map.visible = false
		Event.emit_signal("screenshake", 1.0)
