extends DoorClose

export  var signal_to_emit: String = "boss_door_closed"


func _Interrupt() -> void :
	if signal_to_emit != "none":
		Event.emit_signal(signal_to_emit)
	collider.set_deferred("disabled", false)
