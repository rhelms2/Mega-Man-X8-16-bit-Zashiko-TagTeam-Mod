extends DamageReceiver

signal bike_crash


func _ready() -> void :
	pass

func _on_area2D_body_entered(body: Node) -> void :
	if active:
		if body.is_in_group("Props") and "RideChaser" in body.get_character().name:
			if abs(body.get_character().get_actual_horizontal_speed()) > 325:
				emit_signal("bike_crash")
				call_deferred("destroy_bike", body)

func destroy_bike(body) -> void :
	var bike = body.get_character()
	bike.set_actual_speed(bike.get_actual_speed() / 2)
	bike.current_health = 0
	bike.get_node("Death").emit_remains_particles()
	if bike.is_executing("Riden"):
		bike.get_node("Riden").force_eject()
	bike.force_end("Dash")
	bike.force_end("HyperDash")
	bike.set_direction( - bike.get_direction())
