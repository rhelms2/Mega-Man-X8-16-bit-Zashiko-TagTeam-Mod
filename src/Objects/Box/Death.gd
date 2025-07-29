extends NewAbility
onready var collision_shape_2d: CollisionShape2D = $"../collisionShape2D"
onready var animated_sprite: AnimatedSprite = $"../animatedSprite"
onready var explosion: Particles2D = $explosion
onready var remains_particles: Particles2D = $remains_particles
onready var explosion_sfx: AudioStreamPlayer2D = $explosion_sfx
onready var break_vfx: AnimatedSprite = $break_vfx

signal death

func should_execute() -> bool:
	return true

func _Setup() -> void :
	collision_shape_2d.disabled = true
	animated_sprite.modulate = Color(1, 1, 1, 0.01)
	explosion.emitting = true
	explosion_sfx.play()
	break_vfx.frame = 0
	break_vfx.play()
	remains_particles.emitting = true
	Tools.timer(2, "queue_free", self)
	emit_signal("death")
