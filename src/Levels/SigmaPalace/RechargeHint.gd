extends Node2D

onready var particles: Particles2D = $particles2D
onready var particles2: Particles2D = $particles2D2

func _ready() -> void :
	Event.connect("moved_player_to_checkpoint", self, "on_checkpoint")

func on_checkpoint(checkpoint) -> void :
	if checkpoint.id == 2:
		particles.emitting = true
		particles2.emitting = true

func _on_area2D_body_entered(body: Node) -> void :
	particles.emitting = false
	particles2.emitting = false
	pass
