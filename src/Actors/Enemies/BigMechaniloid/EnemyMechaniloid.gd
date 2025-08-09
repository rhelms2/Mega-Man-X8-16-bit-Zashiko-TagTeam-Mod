extends Enemy

onready var inside_wall = $rigidBody2D/collisionPolygon2D

var started_pursuit := false

signal intro_concluded

signal damage_reduction(_discard)

func _ready() -> void:
	animatedSprite.modulate = Color(1,1,1,0.01)
	Event.connect("moved_player_to_checkpoint",self,"on_checkpoint")

func on_checkpoint(checkpoint : CheckpointSettings) -> void:
	if checkpoint.id >= 1:
		destroy()

func on_spike_land(_discard = null):
	print_debug("On Spike Land called")
	inside_wall.set_deferred("disabled",true)
	current_health = 0
	emit_zero_health_signal()

func _on_MechaStarter_body_entered(body: Node) -> void:
	active = true
	started_pursuit = true

func _on_MechaStarter_left_body_entered(body: Node) -> void:
	active = true
	started_pursuit = true
	$Punch/damage_area.scale.x = -1
	inside_wall.scale.x = -1
	$AI/vision.scale.x = -1
