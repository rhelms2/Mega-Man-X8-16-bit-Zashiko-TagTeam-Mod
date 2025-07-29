extends KinematicBody2D

onready var blocking_wall: CollisionShape2D = $collisionShape2D
onready var animatedSprite: AnimatedSprite = $animatedSprite
onready var remains: Particles2D = $Remains / remains_particles
onready var remains_texture: Texture = preload("res://Zero_mod/Levels/Inferno/remains_Wall.png")

var unlocked: bool = false

func _ready() -> void :
	animatedSprite.animation = "Locked"

func _on_area2D_body_entered(body: Node) -> void :
	if not unlocked:
		if body.is_in_group("Player Projectile"):
			if "Juuhazan_Charged_B" in body.name:
				unlock_secret()
				unlocked = true

func unlock_secret() -> void :
	remains.texture = remains_texture
	remains.emitting = true
	blocking_wall.set_deferred("disabled", true)
	animatedSprite.animation = "Unlocked"
