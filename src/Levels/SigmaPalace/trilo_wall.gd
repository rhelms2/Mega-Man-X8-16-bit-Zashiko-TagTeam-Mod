extends StaticBody2D

onready var collision_right: CollisionShape2D = $collisionShape2DR
onready var collision_left: CollisionShape2D = $collisionShape2DL


func _ready() -> void :
	Event.connect("trilobyte_desperation", self, "activate")
	Event.connect("trilobyte_desperation_end", self, "deactivate")

func activate():
	collision_right.set_deferred("disabled", false)
	collision_left.set_deferred("disabled", false)

func deactivate():
	collision_right.set_deferred("disabled", true)
	collision_left.set_deferred("disabled", true)
