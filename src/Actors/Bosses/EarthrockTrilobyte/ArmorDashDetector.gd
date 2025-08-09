extends Area2D

export var minimum_speed := 100
var player : Actor

signal player_detected
signal dash_detected
signal jump_detected

func _physics_process(delta: float) -> void:
	if player:
		#pode dar problema se tiver com ridearmor ou ridechaser
		if abs(player.get_actual_horizontal_speed()) > minimum_speed:
			emit_signal("dash_detected")
		if player.get_vertical_speed() < -minimum_speed:
			emit_signal("jump_detected")
		else:
			emit_signal("player_detected")

func _on_DashDetector_body_entered(body: Node) -> void:
	player = body.get_parent()

func _on_DashDetector_body_exited(body: Node) -> void:
	player = null
