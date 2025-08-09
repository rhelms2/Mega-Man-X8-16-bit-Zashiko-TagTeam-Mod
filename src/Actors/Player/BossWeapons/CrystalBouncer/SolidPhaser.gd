extends Node2D
onready var collider: CollisionShape2D = $rigidBody2D / collisionShape2D
onready var player_detector: Area2D = $playerDetector

signal phased_in

func _ready() -> void :
	Tools.timer(0.05, "solidify_on_start", self)

func _on_player_exited(body: Node) -> void :
	call_deferred("solidify_collider")

func solidify_on_start() -> void :
	if not is_overlapping_player():
		solidify_collider()

func solidify_collider() -> void :
	collider.disabled = false
	emit_signal("phased_in")

func is_overlapping_player() -> bool:
	return player_detector.overlaps_body(GameManager.player)
