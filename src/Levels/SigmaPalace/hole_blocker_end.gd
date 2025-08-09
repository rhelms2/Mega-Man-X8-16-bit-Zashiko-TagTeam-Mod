extends StaticBody2D
onready var collider: CollisionShape2D = $collisionShape2D


func _ready() -> void :
	Event.connect("enemy_kill", self, "deactivate")

func deactivate(enemy):
	if enemy is String:
		if enemy == "SeraphLumine":
			collider.set_deferred("disabled", false)
