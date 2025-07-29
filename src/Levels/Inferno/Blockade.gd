extends StaticBody2D
onready var visual_block: Node2D = $"../../../Scenery/Stage Segments/_inferno_2/HiddenPassage"
onready var collider: CollisionShape2D = $collisionShape2D

var disappearing: = false
var timer: = 0.0

func open_passage() -> void :
	collider.set_deferred("disabled", true)
	disappearing = true
	Tools.timer(1, "queue_free", self)

func destroy() -> void :
	set_physics_process(false)
	disappearing = false
	visual_block.modulate.a = 0
	queue_free()

func _physics_process(delta: float) -> void :
	if disappearing:
		timer += delta
		visual_block.modulate.a = inverse_lerp( - 1, 1, sin(timer * 120))
		
		if timer > 0.9:
			visual_block.modulate.a = 0
