extends RigidBody2D

onready var collision: CollisionShape2D = $collisionShape2D
onready var tween: = TweenController.new(self, false)
onready var sky_limit: ParallaxLayer = $"../../Scenery/parallaxBackground/sky_limit"

func _on_BossStarter_activated() -> void :
	collision.set_deferred("disabled", false)
	tween.attribute("position:y", collision.position.y - 64, 0.5, collision)
	

func move_bg():
	tween.attribute("motion_offset:y", - 100.0, 0.95, sky_limit)
	
