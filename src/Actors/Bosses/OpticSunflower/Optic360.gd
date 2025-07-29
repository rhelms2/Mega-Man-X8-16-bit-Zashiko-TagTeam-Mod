extends Node2D
class_name Optic360

onready var line: Line2D = $animatedSprite / line
onready var collision: AnimatedSprite = $animatedSprite / collision
onready var ray: RayCast2D = $rayCast2D
onready var collider: CollisionShape2D = $DamageOnTouch / area2D / collisionShape2D
onready var damage_on_touch: Node2D = $DamageOnTouch
onready var animated_sprite: AnimatedSprite = $animatedSprite
onready var collision_noise: AudioStreamPlayer2D = $animatedSprite / collision / collision_noise

var rotation_order: Vector2 = Vector2( - 90.0, 270.0)
var duration: float = 5.0


func _ready() -> void :
	on_ready()

func on_ready() -> void :
	rotation_degrees = rotation_order[0]
	Tools.timer(0.85, "make_visible_and_activate_damage", self)
	Tools.timer(0.85, "activate", self)

func activate() -> void :
	rotate_laser()
	Tools.timer(duration + 0.5, "deactivate", self)

func make_visible_and_activate_damage() -> void :
	animated_sprite.visible = true
	line.visible = true
	collision.visible = true
	damage_on_touch.call_deferred("activate")
	collision_noise.play()
	collision_noise.volume_db = 0

func rotate_laser() -> void :
	Tools.tween(self, "rotation_degrees", rotation_order[1], duration)

func _physics_process(_delta: float) -> void :
	if ray.is_colliding():
		var distance = global_position.distance_to(ray.get_collision_point())
		line.points[1].x = abs(distance)
		collision.position.x = abs(distance)
		collider.scale.x = abs(distance) / 2
		collider.position.x = abs(distance) / 2

func deactivate() -> void :
	disappear_and_throw_leaves()
	Tools.tween(collision_noise, "volume_db", - 80.0, 0.35)
	Tools.timer(1.25, "queue_free", self)

func disappear_and_throw_leaves() -> void :
	rotation_degrees = 0
	animated_sprite.play("end")
	line.visible = false
	collision.visible = false
	animated_sprite.set_physics_process(false)
	damage_on_touch.deactivate()
	$leaves.emitting = true
