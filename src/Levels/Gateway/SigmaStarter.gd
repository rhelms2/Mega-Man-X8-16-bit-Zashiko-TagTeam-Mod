extends Area2D
onready var collider: CollisionShape2D = $collisionShape2D

signal x_detected
var started: = false

func activate():
	collider.set_deferred("disabled", false)


func _on_SigmaStarter_body_entered(_body: Node) -> void :
	if not started:
		started = true
		emit_signal("x_detected")
		GameManager.player.cutscene_deactivate()
		GameManager.music_player.start_slow_fade_out()
		Tools.timer(1.6, "cutscene_deactivate", GameManager.player)
